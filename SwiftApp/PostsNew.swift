//
//  PostsNew.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/29.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct PostsNew: View {
    
    @State var content: String = ""
    @State var detail: String = ""
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
            
                Section(header: Text("今日もお疲れ様！")){
                    Button(action: {
                        PostEntity.create(in: self.viewContext,
                        content: self.content,
                        detail: self.detail)
                        self.save()
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
