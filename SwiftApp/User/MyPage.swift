//
//  MyPage.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/02.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData



struct MyPage: View {

    @ObservedObject var user = UserProfile()
    @State var editProfile = false
    @Environment(\.managedObjectContext) var viewContext
    
    @State var numberOfPosts = 0
    @State var userName = ""
    @State var userGoal = ""
    @State var point = 0
    
    fileprivate func update() {
        self.numberOfPosts = PostEntity.count(in: self.viewContext)
        self.userName = UserProfile().name
        self.userGoal = UserProfile().goal
        self.point = UserProfile().point
    }
    
    var body: some View {
        VStack{
            CircleImage()
            .padding(5)
           
            Text(userName)
                .font(.title)
            
            Button(action: {
                self.editProfile = true
            }) {
                Text("編集")
            }.sheet(isPresented: $editProfile, onDismiss: {self.update()}) {
                EditUser()
            }
            .padding(8)
            
            HStack{
                if userGoal == "" {
                    Text("目標を設定しよう！")
                        .foregroundColor(Color.gray)
                } else {
                    Text(userGoal)
                }
                Spacer()
            }
            .padding(15)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
            .background(Color(red: 1, green: 0.8, blue: 0.3))
            .cornerRadius(10)
            .padding(5)
            
            //ブロックゾーン maxWidthは後でプロパティ調べて修正
            HStack{
                Group{
                    VStack{
                        Text("投稿数")
                            .font(.headline)
                        Text("\(numberOfPosts)")
                    }
                    
                    VStack{
                        Text("えらいポイント")
                        .font(.headline)
                        Text(point.description)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(Color(red: 1, green: 0.7, blue: 0.3))
                .cornerRadius(10)
            }
            .padding(EdgeInsets(
                top: 2,
                leading: 5,
                bottom: 2,
                trailing: 5
            ))
            //プロフィール情報の値が更新されるようにする。
            .onAppear {
                self.update()
            }
        }
    }
}



struct MyPage_Previews: PreviewProvider {

    static var previews: some View {
        MyPage()
    }
}
