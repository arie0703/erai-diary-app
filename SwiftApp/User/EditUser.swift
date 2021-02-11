//
//  EditUser.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/04.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct EditUser: View {
    @ObservedObject var user = UserProfile()
    @Environment(\.presentationMode) var presentationMode
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
                
                
            
            }
            .navigationBarTitle("設定")
        }
    }
}

struct EditUser_Previews: PreviewProvider {
    static var previews: some View {
        EditUser()
    }
}
