//
//  PostTemplate.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/08/05.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData

struct PostTemplate: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var content: String
    @Binding var rate: Int32
    @Binding var starColor2: Color
    @Binding var starColor3: Color
    
    @State var showCreateView = false
    
    let formRed: Double = ColorSetting().formRed
    let formGreen: Double = ColorSetting().formGreen
    let formBlue: Double = ColorSetting().formBlue
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TemplateEntity.created_at,
                                       ascending: false)],
    animation: .default)
    
    var templates: FetchedResults<TemplateEntity>
    
    private func remove(indexSet: IndexSet) {
        for index in indexSet {
            viewContext.delete(templates[index])
        }
        do {
            try viewContext.save()
        } catch {
            fatalError()
        }
    }
    
    var body: some View {
        NavigationView {
            //背景色
            Color(red: formRed, green: formGreen, blue: formBlue)
            .edgesIgnoringSafeArea(.all)
            .overlay(
               
                    
                List {
                    ForEach(templates){ template in
                        Button(action: {
                            content = template.content ?? ""
                            rate = template.rate
                            if rate == 3 {
                                starColor2 = Color.orange
                                starColor3 = Color.orange
                            } else if rate == 2 {
                                starColor2 = Color.orange
                                starColor3 = Color.gray
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text(template.content ?? "")
                                Spacer()
                                Image(systemName: "star.fill")
                                .foregroundColor(Color.orange)
    
                                Text(template.rate.description)
                            }
                            
                        }.listRowBackground(Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 230.0 / 255.0))
                        
                    }
                    .onDelete{ indexSet in
                        self.remove(indexSet: indexSet)
                    }
                
                
                }
                    
                    
                
            )
            .navigationBarTitle("テンプレート", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showCreateView = true
                }) {
                    Image(systemName: "plus")
                    .font(.title)
                }
            ).sheet(isPresented: $showCreateView) {
                CreateTemplate().environment(\.managedObjectContext, self.viewContext)
                    .accentColor(Color.orange)
            }
            .onAppear {
                //ここはCGFloat型なのでカラー変数は使えない
                UITableView.appearance().backgroundColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
            }
        }
        
        
    }
}
