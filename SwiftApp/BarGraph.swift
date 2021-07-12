//
//  BarGraph.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/07/12.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData



struct BarGraph: View {
    
    var body: some View {
        ZStack{

            VStack{
                Text("Daily Posts")
                    .font(.largeTitle)

                HStack(alignment: .center, spacing: 10)
                {
                    ForEach(0..<7){ //六日前から今日までの投稿数を表示させる。
                        num in
                        
                        BarView(value: num)
                    }
                }.padding(.top, 23).animation(.default)
            }
        }
    }


    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .darkGray
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
}

struct BarGraph_Previews: PreviewProvider {
    
    static let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    static let context = container.viewContext
    
    static var previews: some View {
        // テストデータの全削除
    let request = NSBatchDeleteRequest(
       fetchRequest: NSFetchRequest(entityName: "PostEntity"))
    try! container.persistentStoreCoordinator.execute(request, with: context)
        
    // テストデータを追加
    PostEntity.create(in: context,
                     content: "筋トレをした！", detail: "腹筋10回", rate: 3)
    PostEntity.create(in: context,
    content: "バイトをした！!", detail: "一万円稼いだ", rate: 3)
    PostEntity.create(in: context,
                      content: "運動した", detail: "ちょっと歩いた", rate: 3)
    PostEntity.create(in: context,
                      content: "tes", detail: "tes", rate: 3, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        PostEntity.create(in: context,
                          content: "tes", detail: "tes", rate: 3, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        PostEntity.create(in: context,
                          content: "tes", detail: "tes", rate: 3, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        PostEntity.create(in: context,
                          content: "tes", detail: "tes", rate: 3, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)
        PostEntity.create(in: context,
                          content: "tes", detail: "tes", rate: 3, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)
        PostEntity.create(in: context,
                          content: "tes", detail: "tes", rate: 3, date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!)
        PostEntity.create(in: context,
                          content: "tes", detail: "tes", rate: 3, date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!)
        return BarGraph()
            .environment(\.managedObjectContext, context)
            
        
    }
}
