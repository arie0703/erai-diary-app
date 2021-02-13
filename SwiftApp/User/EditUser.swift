//
//  EditUser.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/04.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData

struct EditUser: View {
    @ObservedObject var user = UserProfile()
    @Environment(\.presentationMode) var presentationMode
    
    
    //全削除機能実装のためのEntity, viewContext
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                       ascending: false)],
    animation: .default)
    
    var posts: FetchedResults<PostEntity>
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \RewardEntity.point,
                                       ascending: true)],
    animation: .default)
    
    var rewards: FetchedResults<RewardEntity>
    
    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //postとrewardのデータを全消去
    fileprivate func allDelete() {
        for post in posts {
            viewContext.delete(post)
        }
        
        for reward in rewards {
            viewContext.delete(reward)
        }
        
        save()
    }
    
    //UserDefaultsを初期値に戻す
    func resetUserDefaults() {
        UserDefaults.standard.set("User", forKey: "name")
        UserDefaults.standard.set("", forKey: "goal")
        UserDefaults.standard.set(0, forKey: "point")
        UserDefaults.standard.set(0, forKey: "total_point")
        UserDefaults.standard.set(UIImage(imageLiteralResourceName: "noicon").pngData()!, forKey: "image")
    }
    
    //警告画面
    @State var showingSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ユーザー名")) {
                    TextField("", text: $user.name)
                    
                }
                
                Section(header: Text("目標")) {
                    TextField("例: 一日一回投稿する！", text: $user.goal)
                    
                }
                
                Section (header: Text("えらいポイント")){
                    Text(user.point.description)
                }
                
                Section (header: Text("トータル えらいポイント")){
                    Text(user.total_point.description)
                }
                
                Section{
                    Button(action: {
                        UserDefaults.standard.set(self.user.name, forKey: "name")
                        UserDefaults.standard.set(self.user.goal, forKey: "goal")
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("更新")
                    }
                }
                
                Section{
                    Button(action: {
                        self.showingSheet = true
                    }) {
                        Text("初期化")
                            .foregroundColor(Color.red)
                    }
                }
                
                
                
                
            
            }
            .navigationBarTitle("設定")
            
            //警告画面
            .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("データの初期化"), message: Text("データを全て初期化しますが、よろしいでしょうか？"), buttons: [
                .destructive(Text("初期化を実行")) {
                    allDelete()
                    resetUserDefaults()
                    self.presentationMode.wrappedValue.dismiss()
                },
                .cancel(Text("キャンセル"))
            
            ])
            }
        }
    }
}

struct EditUser_Previews: PreviewProvider {
    static var previews: some View {
        EditUser()
    }
}
