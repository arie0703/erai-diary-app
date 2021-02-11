//
//  RewardNew.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/07.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct RewardNew: View {
    
    @State var content: String = ""
    @State var point_double: Double = 1
    @State var point: Int32 = 0
    
    @Environment(\.managedObjectContext) var viewContext
    
    //モーダルの処理
    @Environment(\.presentationMode) var presentationMode
    
    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    var body: some View {
        NavigationView {
            Form{
                Section(header: Text("ごほうび内容")){
                    TextField("例: プリンを食べる", text: $content)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                
                Section(header: Text("消費ポイント")){
                    Slider(value: $point_double, in: 1...100)
                    Stepper(value: $point_double, in: 1...100) {
                        Text("\(point_double, specifier: "%.0f") ポイント")
                    }
                }
                
                
                
                
                
                
                
            
                Section{
                    Button(action: {
                        self.point = Int32(self.point_double)
                        RewardEntity.create(in: self.viewContext,
                        content: self.content,
                        point: self.point,
                        isDone: false)
                        self.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("追加！")
                    }
                }
            }
            .navigationBarTitle("ごほうびを追加")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "trash")
                .foregroundColor(Color.red)
            })
        }
    }
}

struct RewardNew_Previews: PreviewProvider {
    static var previews: some View {
        RewardNew()
    }
}
