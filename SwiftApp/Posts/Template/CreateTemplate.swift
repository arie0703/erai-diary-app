//
//  CreateTemplate.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/08/06.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct CreateTemplate: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var content: String = ""
    @State var rate: Int32 = 1
    
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
                    Section(header: Text("内容")){
                        TextField("", text: $content)
                    }

                    
                    Section(header: Text("えらい度")){
                        Stepper(value: $rate, in: 1...3) {
                            Text(rate.description + "ポイント")
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                
                    Section{
                        Button(action: {
                            TemplateEntity.create(in: self.viewContext,
                            content: self.content,
                            rate: self.rate,
                            created_at: Date())
                            self.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("追加！")
                        }
                    }
                }
            )
            .navigationBarTitle("テンプレートを追加")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "trash")
                .foregroundColor(Color.red)
            })
        }
    }
    
}
