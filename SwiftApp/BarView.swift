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


struct BarView: View{
    var value: Int
    
    @Environment(\.managedObjectContext) var viewContext

    var postsRequest : FetchRequest<PostEntity>
    
    
    func getTextFromDate(num: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: -6+num, to: Date())
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "M/d"
        return date == nil ? "" : formatter.string(from: date!)
    }
    
    //BarGraphから受け渡される数値は初期化処理をする。
    init(value: Int){
        self.value = value
            self.postsRequest = FetchRequest(entity: PostEntity.entity(),
                                 sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                        ascending: false)],
                                 predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_date(num: value) as NSDate, end_of_date(num: value) as NSDate)
                                )

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
                        .frame(width: 30, height: CGFloat(postList.count * 30)).foregroundColor(.orange)
                    Text(postList.count.description).font(.footnote).foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                    
                }.padding(.bottom, 8)
                
            }
            Text(getTextFromDate(num: value)) //棒グラフに対応する日付を表示
                .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
        }
        
    }
}
