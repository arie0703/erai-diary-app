//
//  BarViewPerMonth.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/07/23.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData


struct BarViewPerMonth: View{
    
    @Environment(\.managedObjectContext) var viewContext
    @State var arr: Array<Int> = [0,0,0,0,0,0,0]
    @State var scope: Float = 0.0
    var width: Int
    var height: Int
    
    
    func getMonthFromDate(num: Int) -> String {
        let date = Calendar.current.date(byAdding: .month, value: -6+num, to: Date())
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "M"
        return date == nil ? "" : formatter.string(from: date!)
    }
    
    func getHeightOfBar(num: Int, scope: Float) -> Float {
        let height = Float(num) * scope
        
        return height
    }
    
    init(width: Int, height: Int){
        self.width = width
        self.height = height
    }
    

    func start_of_month(num: Int) -> Date {
        let date = Calendar.current.date(byAdding: .month, value: -num, to: Date()) // nヶ月前の今日の日付を取得
        let comps = Calendar.current.dateComponents([.year, .month], from: date!) // nヶ月前の今日
        let start_of_month = Calendar.current.date(from: comps)!

        return start_of_month
    }
    func end_of_month(num: Int) -> Date {
        let date = Calendar.current.date(byAdding: .month, value: -num, to: Date()) // nヶ月前の今日の日付を取得
        let comps = Calendar.current.dateComponents([.year, .month], from: date!) // nヶ月前の今日
        let start_of_month = Calendar.current.date(from: comps)
        let add = DateComponents(month: 1, day: -1)
        let lastday = Calendar.current.date(byAdding: add, to: start_of_month!) //月の最終日を取得
        let end_of_month = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: lastday!)! //月末の23:59:59を取得
        
        return end_of_month
    }
    
    func getSumOfPointsInEachMonth(in managedObjectContext: NSManagedObjectContext, num: Int) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        //今日の初めから終わりまでの投稿を取得
        fetchRequest.predicate = NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_month(num: num) as NSDate, end_of_month(num: num) as NSDate)
        //取得するデータ名はsumとする
        let expressionName = "sum"
        //rateの値をとる
        let keyPathExpression = NSExpression(forKeyPath: "rate")
        //ここで取ってきたデータのrateの合計値を算出する。
        let expression = NSExpression(forFunction: "sum:", arguments: [keyPathExpression])
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = expressionName
        expressionDescription.expression = expression
        expressionDescription.expressionResultType = NSAttributeType.integer32AttributeType
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest).first
            let result = results as! Dictionary<String, Int>
            let sum = result[expressionName]
            return sum ?? 0
                
        } catch  {
            print("Error: \(error.localizedDescription)")
            return 0
        }
    }
    
    
    fileprivate func updatePoints() {
        self.arr = [getSumOfPointsInEachMonth(in: viewContext, num: 6),
                   getSumOfPointsInEachMonth(in: viewContext, num: 5),
                   getSumOfPointsInEachMonth(in: viewContext, num: 4),
                   getSumOfPointsInEachMonth(in: viewContext, num: 3),
                   getSumOfPointsInEachMonth(in: viewContext, num: 2),
                   getSumOfPointsInEachMonth(in: viewContext, num: 1),
                   getSumOfPointsInEachMonth(in: viewContext, num: 0)
        ]
        if (arr.max()! > 0) {
            self.scope = 180.0 / Float(arr.max()!)
        } else {
            self.scope = 0
        }
    }
    

    
    
    var body: some View {
        
        ForEach(0..<7){ i in
            VStack {
                VStack {
                    ZStack (alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: CGFloat(width), height: CGFloat(height)).foregroundColor(Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 235.0 / 255.0))
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: CGFloat(width), height: CGFloat(getHeightOfBar(num: arr[i], scope: scope))).foregroundColor(.orange)
                        Text(arr[i].description).font(.footnote).foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                        
                    }.padding(.bottom, 8)
                    
                }
                
                Text(getMonthFromDate(num: i) + "月") //棒グラフに対応する週の開始日を表示
                    .font(.caption)
                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                
            }
        }.onAppear {
            self.updatePoints() //グラフが表示されるたびに数値を更新して再描画メソッドを呼び出す。
        }
        
    }
}

