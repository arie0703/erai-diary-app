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

    var postsRequest1 : FetchRequest<PostEntity>
    var postsRequest2 : FetchRequest<PostEntity>
    var postsRequest3 : FetchRequest<PostEntity>
    var postsRequest4 : FetchRequest<PostEntity>
    var postsRequest5 : FetchRequest<PostEntity>
    var postsRequest6 : FetchRequest<PostEntity>
    var postsRequest7 : FetchRequest<PostEntity>
    
    
    
    
    
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
    init(){
        
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
        
        self.postsRequest1 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_week(num: 6) as NSDate, end_of_week(num: 6) as NSDate)
                            )
        self.postsRequest2 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_week(num: 5) as NSDate, end_of_week(num: 5) as NSDate)
                            )
        self.postsRequest3 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_week(num: 4) as NSDate, end_of_week(num: 4) as NSDate)
                            )
        self.postsRequest4 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_week(num: 3) as NSDate, end_of_week(num: 3) as NSDate)
                            )
        self.postsRequest5 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_week(num: 2) as NSDate, end_of_week(num: 2) as NSDate)
                            )
        self.postsRequest6 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_week(num: 1) as NSDate, end_of_week(num: 1) as NSDate)
                            )
        self.postsRequest7 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_week(num: 0) as NSDate, end_of_week(num: 0) as NSDate)
                            )
        
        
        
        }
    
            
       
    
    //指定された日付の投稿を取得 .countプロパティで投稿数を取得
    var postList1: FetchedResults<PostEntity>{postsRequest1.wrappedValue}
    var postList2: FetchedResults<PostEntity>{postsRequest2.wrappedValue}
    var postList3: FetchedResults<PostEntity>{postsRequest3.wrappedValue}
    var postList4: FetchedResults<PostEntity>{postsRequest4.wrappedValue}
    var postList5: FetchedResults<PostEntity>{postsRequest5.wrappedValue}
    var postList6: FetchedResults<PostEntity>{postsRequest6.wrappedValue}
    var postList7: FetchedResults<PostEntity>{postsRequest7.wrappedValue}
    
    

    
    
    var body: some View {
        let arr: Array<Int> = [postList1.count,postList2.count,postList3.count,postList4.count,postList5.count,postList6.count,postList7.count]
        let scope: Float = 180.0 / Float(arr.max()!) //6週間前から今週まで、もっとも投稿数の多い週のグラフのheightが180になるよう調整する。
        ForEach(0..<7){ i in
            VStack {
                VStack {
                    ZStack (alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 30, height: 200).foregroundColor(Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 235.0 / 255.0))
                        if(arr.max()! > 0) {
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 30, height: CGFloat(getHeightOfBar(num: arr[i], scope: scope))).foregroundColor(.orange)
                        } else {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: 30, height: CGFloat(getHeightOfBar(num: arr[i], scope: 0))).foregroundColor(.orange)
                        }
                        Text(arr[i].description).font(.footnote).foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                        
                    }.padding(.bottom, 8)
                    
                }
                
                Text(getWeekFromDate(num: i)) //棒グラフに対応する週の開始日を表示
                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                
            }
        }
        
    }
}

