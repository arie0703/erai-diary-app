//
//  PostsSortedByDate.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/02/14.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData


func start(date: Date) -> Date {
    let day1 = Calendar(identifier: .gregorian).startOfDay(for: date)
    
    return day1
}

func end(date: Date) -> Date {
    let day2 = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: date)!
    return day2
}






struct PostsSortedByDate: View {
    
    @Environment(\.managedObjectContext) var viewContext

    var selectedDate : Date
    var postsRequest : FetchRequest<PostEntity>
    
    init(selectedDate: Date){
            self.selectedDate = selectedDate
            self.postsRequest = FetchRequest(entity: PostEntity.entity(),
                                             sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                                                                                    ascending: false)],
                                             predicate: NSPredicate(format:"date BETWEEN {%@ , %@}", start(date: selectedDate) as NSDate, end(date: selectedDate) as NSDate)
                                            )

    }
    

    var postList: FetchedResults<PostEntity>{postsRequest.wrappedValue}
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(getTextFromDate(date: selectedDate) + "の投稿")
            .font(.title)
            .padding(10)
            
            ScrollView(.vertical, showsIndicators: false){
                ForEach(postList, id: \.self){ post in
                    
                    PostRow(post: post)
                    
                }
            }
            
            
        }
    }
    
    func getTextFromDate(date: Date!) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy/MM/dd/"
        return date == nil ? "" : formatter.string(from: date)
    }
}

