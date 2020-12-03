//
//  MyPage.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/02.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

var userName: String = "user"
struct MyPage: View {
    var body: some View {
        
        VStack{
            CircleImage(image: Image("noicon"))
            .padding(5)
           
            Text(userName)
                .font(.title)
            HStack{
            Text("編集")
                .padding(5)
            Text("設定")
                .padding(5)
            }
            
            HStack{
                Text("こんにちは！")
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
                    Text("100")
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
