//
//  PostsNew.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/29.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct PostsNew: View {
    @ObservedObject var user = UserProfile()
    
    @State var content: String = ""
    @State var detail: String = ""
    @State var date = Date()
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
    
    //星の色　ボタンでチェンジ　デフォルトで星1は色がついてる
    @State var starColor1 = Color.orange
    @State var starColor2 = Color.gray
    @State var starColor3 = Color.gray
    
    @State var rate: Int = 1
    
    func changeStar() {
        if rate == 1 {
            starColor2 = Color.gray
            starColor3 = Color.gray
        } else if rate == 2 {
            starColor2 = Color.orange
            starColor3 = Color.gray
        } else {
            starColor2 = Color.orange
            starColor3 = Color.orange
        }
    }
    
    
    fileprivate func cancelPost() {
        self.detail = ""
    }
    
    var body: some View {
        NavigationView {
            Form{
                Section(header: Text("今日あったえらい出来事")){
                    TextField("例: 三食しっかり食べた！", text: $content)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Section(header: Text("ひとこと")){
                    TextField("", text: $detail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: Text("えらい度")){
                    VStack{
                        HStack{
                            Spacer()
                        
                            Image(systemName: "star.fill")
                            .foregroundColor(starColor1)
                            .font(.title)
                            .padding(10)
                        
            
                            Image(systemName: "star.fill")
                            .foregroundColor(starColor2)
                                .font(.title)
                            .padding(10)
                        
                        
                       
                            Image(systemName: "star.fill")
                            .foregroundColor(starColor3)
                            .font(.title)
                            .padding(10)
                            
                            Spacer()
                        }
                        Text(rate.description)
                    }
                }
                Button(action: {
                    self.rate = 1
                    self.changeStar()
                }){
                    Text("ちょっとえらい")
                }
                Button(action: {
                    self.rate = 2
                    self.changeStar()
                }){
                    Text("えらい！")
                }
                Button(action: {
                    self.rate = 3
                    self.changeStar()
                }){
                    Text("スーパーえらい！！")
                }
                
                    
                
                Section(header: Text("日時")) {
                    
                    DatePicker("日時", selection: $date, displayedComponents: .date)
                    
                }
                
            
                Section(header: Text("今日もお疲れ様！")){
                    Button(action: {
                        PostEntity.create(in: self.viewContext,
                        content: self.content,
                        detail: self.detail,
                        date: self.date)
                        self.save()
                        UserDefaults.standard.set(self.user.point + self.rate, forKey: "point")
                        
                        UserDefaults.standard.set(self.user.total_point + self.rate, forKey: "total_point")
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("投稿！")
                    }
                }
            }
            .navigationBarTitle("投稿する")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "trash")
                .foregroundColor(Color.red)
            })
        }
    }
}

struct PostsNew_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
    .persistentContainer.viewContext
    static var previews: some View {
        PostsNew()
        .environment(\.managedObjectContext, context)
    }
}
