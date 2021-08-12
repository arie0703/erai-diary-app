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
    @State var showingAlert = false
    
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
    
    init(){
        //formの背景色を設定できるように
        UITableView.appearance().backgroundColor = .clear
    }
    
    let formRed: Double = ColorSetting().formRed
    let formGreen: Double = ColorSetting().formGreen
    let formBlue: Double = ColorSetting().formBlue
    
    var body: some View {
        NavigationView {
            Color(red: formRed, green: formGreen, blue: formBlue)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                Form{
                    Section(header: Text("ごほうび内容")){
                        TextField("例: プリンを食べる", text: $content)
                    }

                    
                    Section(header: Text("消費ポイント")){
                        Slider(value: $point_double, in: 1...100, step: 1)
                        Stepper(value: $point_double, in: 1...100) {
                            Text("\(point_double, specifier: "%.0f") ポイント")
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                
                    Section{
                        Button(action: {
                            if self.content == "" {
                                self.showingAlert = true
                            } else {
                                self.point = Int32(self.point_double)
                                RewardEntity.create(in: self.viewContext,
                                content: self.content,
                                point: self.point,
                                isDone: false)
                                self.save()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("追加！")
                        }.alert(isPresented: self.$showingAlert) {
                            Alert(
                                  title: Text("エラー"),
                                  message: Text("ごほうび内容を入力してください。")
                            )
                        }
                    }
                }
            )
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
