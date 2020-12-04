//
//  MyPage.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/02.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

var userName: String = "user"


//User defaultsを設定
class UserProfile: ObservableObject {

    @Published var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    
    @Published var goal: String {
        didSet {
            UserDefaults.standard.set(goal, forKey: "goal")
        }
    }
    
    @Published var point: Int {
        didSet {
            UserDefaults.standard.set(point, forKey: "point")
        }
    }
    
    /// 初期化処理
    init() {
        name = UserDefaults.standard.string(forKey: "name") ?? "ユーザー"
        goal = UserDefaults.standard.string(forKey: "goal") ?? "目標を設定しよう！"
        point = UserDefaults.standard.object(forKey: "point") as? Int ?? 0
    }
}

struct MyPage: View {

    @ObservedObject var user = UserProfile()
    @State var editProfile = false
    
    var body: some View {
        VStack{
            CircleImage(image: Image("noicon"))
            .padding(5)
           
            Text(user.name)
                .font(.title)
            HStack{
            Button(action: {
                self.editProfile = true
            }) {
                Text("編集")
            }.sheet(isPresented: $editProfile) {
                EditUser()
            }
            Text("設定")
                .padding(5)
            }
            
            HStack{
                Text(user.goal)
                Spacer()
            }
            .padding(15)
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(red: 1, green: 0.9, blue: 0.5))
            .cornerRadius(10)
            .padding(10)
            
            //ブロックゾーン maxWidthは後でプロパティ調べて修正
            HStack{
                VStack{
                    Text("投稿数")
                        .font(.headline)
                    Text("4")
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color(red: 1, green: 0.7, blue: 0.6))
                .cornerRadius(10)
                VStack{
                    Text("えらいポイント")
                    .font(.headline)
                    Text(user.point.description)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color(red: 1, green: 0.6, blue: 0.8))
                .cornerRadius(10)
            }
        .padding(10)
            
            Text("この調子で頑張ろう！")
            Spacer()
        }
    }
}



struct MyPage_Previews: PreviewProvider {

    static var previews: some View {
        MyPage()
    }
}
