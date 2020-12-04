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
                Section(header: Text(user.name)) {
                    TextField("ユーザー名", text: $user.name)
                    
                }
                
                Section(header: Text("今日もお疲れ様！")){
                    Button(action: {
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("投稿！")
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
