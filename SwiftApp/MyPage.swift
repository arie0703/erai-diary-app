//
//  MyPage.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/02.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

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
    
    @Published var total_point: Int {
        didSet {
            UserDefaults.standard.set(point, forKey: "total_point")
        }
    }
    
    /// 初期化処理
    init() {
        name = UserDefaults.standard.string(forKey: "name") ?? "ユーザー"
        goal = UserDefaults.standard.string(forKey: "goal") ?? ""
        point = UserDefaults.standard.integer(forKey: "point")
        total_point = UserDefaults.standard.integer(forKey: "total_point")
    }
}

//編集画面で更新した値がすぐ反映されるようにグローバル変数を用意しておく
var userName = UserProfile().name
var userGoal = UserProfile().goal
var userPoint = UserProfile().point

struct MyPage: View {

    @ObservedObject var user = UserProfile()
    @State var editProfile = false
    
    
    var body: some View {
        VStack{
            CircleImage(image: Image("noicon"))
            .padding(5)
           
            Text(userName)
                .font(.title)
            
            Button(action: {
                self.editProfile = true
            }) {
                Text("編集")
            }.sheet(isPresented: $editProfile) {
                EditUser()
            }
            .padding(10)
            
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
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(red: 1, green: 0.8, blue: 0.3))
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
                .background(Color(red: 1, green: 0.7, blue: 0.3))
                .cornerRadius(10)
                VStack{
                    Text("えらいポイント")
                    .font(.headline)
                    Text(userPoint.description)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color(red: 1, green: 0.7, blue: 0.3))
                .cornerRadius(10)
            }
        .padding(10)
            //手書きキャラクターとか入れたら面白いかも！
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
