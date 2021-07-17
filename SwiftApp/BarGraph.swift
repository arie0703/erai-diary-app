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
    
    @State var pickerSelection = 2

    var body: some View {
        ZStack{

            VStack{
                Text("Daily Posts")
                    .font(.largeTitle)
                Picker(selection: $pickerSelection, label: Text("Picker"))
                                    {
                                    Text("Month").tag(0)
                                    Text("Week").tag(1)
                                    Text("Day").tag(2)
                                }.pickerStyle(SegmentedPickerStyle())
                                    .padding(.horizontal, 10)

                HStack(alignment: .center, spacing: 10)
                {
                    ForEach(0..<7){ //六日前から今日までの投稿数を表示させる。
                        num in
                        
                        BarView(value: num, pickerSelection: pickerSelection)
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
        
        for i in 0..<12 {
            PostEntity.create(in: context,
                              content: "tes", detail: "tes", rate: 3, date: Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())!)
            PostEntity.create(in: context,
                              content: "tes", detail: "tes", rate: 3, date: Calendar.current.date(byAdding: .day, value: -i, to: Date())!)
        }
        
    
    
    PostEntity.create(in: context,
                     content: "筋トレをした！", detail: "腹筋10回", rate: 3)
    PostEntity.create(in: context,
    content: "バイトをした！!", detail: "一万円稼いだ", rate: 3)
    PostEntity.create(in: context,
                      content: "運動した", detail: "ちょっと歩いた", rate: 3)
        return BarGraph()
            .environment(\.managedObjectContext, context)
            
        
    }
}
