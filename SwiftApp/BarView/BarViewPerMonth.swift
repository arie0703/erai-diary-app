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

    var postsRequest1 : FetchRequest<PostEntity>
    var postsRequest2 : FetchRequest<PostEntity>
    var postsRequest3 : FetchRequest<PostEntity>
    var postsRequest4 : FetchRequest<PostEntity>
    var postsRequest5 : FetchRequest<PostEntity>
    var postsRequest6 : FetchRequest<PostEntity>
    var postsRequest7 : FetchRequest<PostEntity>
    
    
    
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
    
    init(){ //初期化処理に各月の初日0:00:00と最終日23:59:59を取得する関数と、各月の投稿を取得するFetchRequestを記述する。
        
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
        
        self.postsRequest1 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_month(num: 6) as NSDate, end_of_month(num: 6) as NSDate)
                            )
        self.postsRequest2 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_month(num: 5) as NSDate, end_of_month(num: 5) as NSDate)
                            )
        self.postsRequest3 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_month(num: 4) as NSDate, end_of_month(num: 4) as NSDate)
                            )
        self.postsRequest4 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_month(num: 3) as NSDate, end_of_month(num: 3) as NSDate)
                            )
        self.postsRequest5 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_month(num: 2) as NSDate, end_of_month(num: 2) as NSDate)
                            )
        self.postsRequest6 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_month(num: 1) as NSDate, end_of_month(num: 1) as NSDate)
                            )
        self.postsRequest7 = FetchRequest(entity: PostEntity.entity(),
                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                    ascending: false)],
                             
                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_month(num: 0) as NSDate, end_of_month(num: 0) as NSDate)
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
        let scope: Float = 180.0 / Float(arr.max()!)
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
                
                Text(getMonthFromDate(num: i) + "月") //棒グラフに対応する週の開始日を表示
                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                
            }
        }
        
    }
}

