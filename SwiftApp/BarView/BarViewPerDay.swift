//
//  BarViewPerDay.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/07/23.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData


struct BarViewPerDay: View{
    
    @Environment(\.managedObjectContext) var viewContext
    @State var arr: Array<Int> = [0,0,0,0,0,0,0]
    @State var scope: Float = 0.0
    var width: Int
    var height: Int
    
    func getTextFromDate(num: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: -6+num, to: Date())
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "M/d"
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
    
    func start_of_date(num: Int) -> Date {
        let date = Calendar.current.date(byAdding: .day, value: -num, to: Date())
        let start_of_date = Calendar(identifier: .gregorian).startOfDay(for: date!)

        return start_of_date
    }

    func end_of_date(num: Int) -> Date {
        let date = Calendar.current.date(byAdding: .day, value: -num, to: Date())
        let end_of_date = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: date!)!
        return end_of_date
    }
    
    func getSumOfPointsInEachDay(in managedObjectContext: NSManagedObjectContext, num: Int) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        //今日の初めから終わりまでの投稿を取得
        fetchRequest.predicate = NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_date(num: num) as NSDate, end_of_date(num: num) as NSDate)
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
        self.arr = [getSumOfPointsInEachDay(in: viewContext, num: 6),
                    getSumOfPointsInEachDay(in: viewContext, num: 5),
                    getSumOfPointsInEachDay(in: viewContext, num: 4),
                    getSumOfPointsInEachDay(in: viewContext, num: 3),
                    getSumOfPointsInEachDay(in: viewContext, num: 2),
                    getSumOfPointsInEachDay(in: viewContext, num: 1),
                    getSumOfPointsInEachDay(in: viewContext, num: 0)
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
                        if(arr.max()! > 0) { //投稿数が全部ゼロだと全部heightが百八十になってしまう
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: CGFloat(width), height: CGFloat(getHeightOfBar(num: arr[i], scope: scope))).foregroundColor(.orange)
                        } else {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: CGFloat(width), height: CGFloat(getHeightOfBar(num: arr[i], scope: 0))).foregroundColor(.orange)
                        }
                        Text(arr[i].description).font(.footnote).foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                        
                    }.padding(.bottom, 8)
                    
                }
                
                Text(getTextFromDate(num: i)) //棒グラフに対応する週の開始日を表示
                    .font(.caption)
                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                
            }
        }.onAppear {
            self.updatePoints() //グラフが表示されるたびに数値を更新して再描画メソッドを呼び出す。
        }
    }
}


