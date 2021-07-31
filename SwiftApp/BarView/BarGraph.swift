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
    
    init() { // Pickerの色を指定する。
        UISegmentedControl.appearance().backgroundColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0) //背景色
        UISegmentedControl.appearance().selectedSegmentTintColor = .orange //選択された時の背景色
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected) //選択された時の文字色
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red:0.64, green:0.5, blue: 0.33, alpha: 1.0)], for: .normal) //選択されてない文字の色
    }

    var body: some View {
        ZStack{

            VStack{
                Text("レポート")
                    .font(.title)
                    .padding(5)
                Text("月・週・日ごとの獲得ポイント")
                    .font(.body)
                Picker(selection: $pickerSelection, label: Text("Picker"))
                                    {
                                    Text("月").tag(0)
                                    Text("週").tag(1)
                                    Text("日").tag(2)
                                }.pickerStyle(SegmentedPickerStyle())
                                    .padding(.horizontal, 10)

                HStack(alignment: .center, spacing: 10)
                {
                    switch pickerSelection {
                    case 0:
                        BarViewPerMonth(width: 30, height: 180)
                    case 1:
                        BarViewPerWeek(width: 30, height: 180)
                    case 2:
                        BarViewPerDay(width: 30, height: 180)
                    default:
                        BarViewPerDay(width: 30, height: 180)
                    }
                }.padding(.top, 23).animation(.default)
            }
            
        }
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
