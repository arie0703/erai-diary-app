//
//  BarView.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/07/12.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData
import Foundation

func start_of_date(num: Int) -> Date {
    let date = Calendar.current.date(byAdding: .day, value: -6+num, to: Date())
    let start_of_date = Calendar(identifier: .gregorian).startOfDay(for: date!)

    return start_of_date
}

func end_of_date(num: Int) -> Date {
    let date = Calendar.current.date(byAdding: .day, value: -6+num, to: Date())
    let end_of_date = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: date!)!
    return end_of_date
}
func start_of_month(num: Int) -> Date {
    let date = Calendar.current.date(byAdding: .month, value: -6+num, to: Date()) // nヶ月前の今日の日付を取得
    let comps = Calendar.current.dateComponents([.year, .month], from: date!) // nヶ月前の今日
    let start_of_month = Calendar.current.date(from: comps)!

    return start_of_month
}
func end_of_month(num: Int) -> Date {
    let date = Calendar.current.date(byAdding: .month, value: -6+num, to: Date()) // nヶ月前の今日の日付を取得
    let comps = Calendar.current.dateComponents([.year, .month], from: date!) // nヶ月前の今日
    let start_of_month = Calendar.current.date(from: comps)
    let add = DateComponents(month: 1, day: -1)
    let lastday = Calendar.current.date(byAdding: add, to: start_of_month!) //月の最終日を取得
    let end_of_month = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: lastday!)! //月末の23:59:59を取得
    
    return end_of_month
}

func start_of_week(num: Int) -> Date {
    let thisWeekDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday! //今日の曜日を数値で取得（日から土で1~7）
    let n = thisWeekDay - 1
    let start_of_thisweek = Calendar.current.date(byAdding: .day, value: -n, to: Date())! //今週の日曜日を取得
    let week = Calendar.current.date(byAdding: .weekOfMonth, value: -6+num, to: start_of_thisweek)! //ここで今日の日付から任意の週巻き戻した日時を取得
    let start_of_date = Calendar(identifier: .gregorian).startOfDay(for: week) //weekで取得した日付の始まりの時刻を取得

    return start_of_date
}

func end_of_week(num: Int) -> Date {
    let thisWeekDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday! //今日の曜日を数値で取得（日から土で1~7）
    let n = 7 - thisWeekDay
    let end_of_thisweek = Calendar.current.date(byAdding: .day, value: n, to: Date())! //今週の土曜日を取得
    let week = Calendar.current.date(byAdding: .weekOfMonth, value: num-6, to: end_of_thisweek)! //ここで今日の日付から任意の週巻き戻した日時を取得
    let end_of_date = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: week)! //weekで取得した日付の23:59:59を取得
    return end_of_date
}


struct BarView: View{
    //BarGraphから受け取る値
    var value: Int
    var pickerSelection: Int
    
    @Environment(\.managedObjectContext) var viewContext

    var postsRequest : FetchRequest<PostEntity>
    
    
    func getTextFromDate(num: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: -6+num, to: Date())
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "M/d"
        return date == nil ? "" : formatter.string(from: date!)
    }
    
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
    
    func getMonthFromDate(num: Int) -> String {
        let date = Calendar.current.date(byAdding: .month, value: -6+num, to: Date())
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MM"
        return date == nil ? "" : formatter.string(from: date!)
    }
    
    func getHeightOfBar(num: Int) -> Int {
        var height = num * 20
        
        if height > 200 { // 投稿数が多くてbarのheightが上限を超えないように関数で処理する
            height = 200
        }
        return height
    }
    
    //BarGraphから受け渡される数値は初期化処理をする。
    init(value: Int, pickerSelection: Int){
        self.value = value
        self.pickerSelection = pickerSelection
        
        switch pickerSelection {
        case 0: //Month
            self.postsRequest = FetchRequest(entity: PostEntity.entity(),
                                 sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                        ascending: false)],
                                 
                                 predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_month(num: value) as NSDate, end_of_month(num: value) as NSDate)
                                )
        case 1: //Week
            self.postsRequest = FetchRequest(entity: PostEntity.entity(),
                                 sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                        ascending: false)],
                                 
                                 predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_week(num: value) as NSDate, end_of_week(num: value) as NSDate)
                                )
        case 2: //Day
            self.postsRequest = FetchRequest(entity: PostEntity.entity(),
                                 sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                        ascending: false)],
                                 
                                 predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_date(num: value) as NSDate, end_of_date(num: value) as NSDate)
                                )
        default:
            self.postsRequest = FetchRequest(entity: PostEntity.entity(),
                                 sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                        ascending: false)],
                                 
                                 predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_date(num: value) as NSDate, end_of_date(num: value) as NSDate)
                                )
        }
            
       
            

    }
    
    //指定された日付の投稿を取得 .countプロパティで投稿数を取得
    var postList: FetchedResults<PostEntity>{postsRequest.wrappedValue}
    
    var body: some View {
        VStack {
            VStack {

                ZStack (alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 30, height: 200).foregroundColor(Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 235.0 / 255.0))
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 30, height: CGFloat(getHeightOfBar(num: postList.count))).foregroundColor(.orange)
                    Text(postList.count.description).font(.footnote).foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                    
                }.padding(.bottom, 8)
                
            }
            switch pickerSelection {
            case 0:
                Text(getMonthFromDate(num: value)) //棒グラフに対応する日付を表示
                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
            
            case 1:
                Text(getWeekFromDate(num: value)) //棒グラフに対応する週の開始日を表示
                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
            
            case 2:
                Text(getTextFromDate(num: value)) //棒グラフに対応する月を表示
                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
            
            default:
                Text(getTextFromDate(num: value)) //棒グラフに対応する日付を表示
                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
    
            }
            
        }
        
    }
}
