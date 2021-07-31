//  BarView.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/07/12.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData
import Foundation



//func start_of_week(num: Int) -> Date {
//    let thisWeekDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday! //今日の曜日を数値で取得（日から土で1~7）
//    let n = thisWeekDay - 1
//    let start_of_thisweek = Calendar.current.date(byAdding: .day, value: -n, to: Date())! //今週の日曜日を取得
//    let week = Calendar.current.date(byAdding: .weekOfMonth, value: -6+num, to: start_of_thisweek)! //ここで今日の日付から任意の週巻き戻した日時を取得
//    let start_of_date = Calendar(identifier: .gregorian).startOfDay(for: week) //weekで取得した日付の始まりの時刻を取得
//
//    return start_of_date
//}
//
//func end_of_week(num: Int) -> Date {
//    let thisWeekDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday! //今日の曜日を数値で取得（日から土で1~7）
//    let n = 7 - thisWeekDay
//    let end_of_thisweek = Calendar.current.date(byAdding: .day, value: n, to: Date())! //今週の土曜日を取得
//    let week = Calendar.current.date(byAdding: .weekOfMonth, value: num-6, to: end_of_thisweek)! //ここで今日の日付から任意の週巻き戻した日時を取得
//    let end_of_date = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: week)! //weekで取得した日付の23:59:59を取得
//    return end_of_date
//}


struct BarViewPerWeek: View{
    
    @Environment(\.managedObjectContext) var viewContext
    @State var arr: Array<Int> = [0,0,0,0,0,0,0]
    @State var scope: Float = 0.0
    
    var width: Int
    var height: Int
    
    
    
    func getWeekFromDate(num: Int) -> String {
        let thisWeekDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday! //今日の曜日を数値で取得（日から土で1~7）
        let n = thisWeekDay - 1
        let start_of_thisweek = Calendar.current.date(byAdding: .day, value: -n, to: Date())! //今週の日曜日を取得
        let date = Calendar.current.date(byAdding: .weekOfMonth, value: -6+num, to: start_of_thisweek)! //ここで今日の日付から任意の週巻き戻した日時を取得
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
    
    func getHeightOfBar(num: Int, scope: Float) -> Float { // 一番投稿数が多い週のグラフの長さが最大となるように調整する
        let height = Float(num) * scope
        
        return height
    }
    
    //6週間前から今週まで週ごとの投稿をそれぞれ取得する
    init(width: Int, height: Int){
        
        self.width = width
        self.height = height
        
        
        
        }
    
            
       
    
    func start_of_week(num: Int) -> Date {
        let thisWeekDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday! //今日の曜日を数値で取得（日から土で1~7）
        let n = thisWeekDay - 1
        let start_of_thisweek = Calendar.current.date(byAdding: .day, value: -n, to: Date())! //今週の日曜日を取得
        let week = Calendar.current.date(byAdding: .weekOfMonth, value: -num, to: start_of_thisweek)! //ここで今日の日付から任意の週巻き戻した日時を取得
        let start_of_date = Calendar(identifier: .gregorian).startOfDay(for: week) //weekで取得した日付の始まりの時刻を取得

        return start_of_date
    }

    func end_of_week(num: Int) -> Date {
        let thisWeekDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday! //今日の曜日を数値で取得（日から土で1~7）
        let n = 7 - thisWeekDay
        let end_of_thisweek = Calendar.current.date(byAdding: .day, value: n, to: Date())! //今週の土曜日を取得
        let week = Calendar.current.date(byAdding: .weekOfMonth, value: -num, to: end_of_thisweek)! //num週間前の日付を取得
        let end_of_date = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: week)! //weekで取得した日付の23:59:59を取得
        return end_of_date
    }
    
    func getSumOfPointsInEachWeek(in managedObjectContext: NSManagedObjectContext, num: Int) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        //今日の初めから終わりまでの投稿を取得
        fetchRequest.predicate = NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_week(num: num) as NSDate, end_of_week(num: num) as NSDate)
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
        self.arr = [getSumOfPointsInEachWeek(in: viewContext, num: 6),
                    getSumOfPointsInEachWeek(in: viewContext, num: 5),
                    getSumOfPointsInEachWeek(in: viewContext, num: 4),
                    getSumOfPointsInEachWeek(in: viewContext, num: 3),
                    getSumOfPointsInEachWeek(in: viewContext, num: 2),
                    getSumOfPointsInEachWeek(in: viewContext, num: 1),
                    getSumOfPointsInEachWeek(in: viewContext, num: 0)
        ]
        if (arr.max()! > 0) {
            self.scope = 180.0 / Float(arr.max()!)
        } else {
            self.scope = 0
        }
    }

    
    
    var body: some View {
        
         //6週間前から今週まで、もっとも投稿数の多い週のグラフのheightが180になるよう調整する。
        ForEach(0..<7){ i in
            VStack {
                VStack {
                    ZStack (alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: CGFloat(width), height: CGFloat(height)).foregroundColor(Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 235.0 / 255.0))
                        if(arr.max()! > 0) {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: CGFloat(width), height: CGFloat(getHeightOfBar(num: arr[i], scope: scope))).foregroundColor(.orange)
                        } else {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: CGFloat(width), height: CGFloat(getHeightOfBar(num: arr[i], scope: 0))).foregroundColor(.orange)
                        }
                        Text(arr[i].description).font(.footnote).foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                        
                    }.padding(.bottom, 8)
                    
                    
                }
                
                Text(getWeekFromDate(num: i)) //棒グラフに対応する週の開始日を表示
                    .font(.caption)
                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                
            }
        }.onAppear {
            self.updatePoints() //グラフが表示されるたびに数値を更新して再描画メソッドを呼び出す。
        }
        
    }
}

