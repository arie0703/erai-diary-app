//
//  GoalSheet.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/02.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct GoalSheet: View {
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("ごほうびシート")
                .font(.title)
                Spacer()
                
                Image(systemName: "plus")
            }
            
            Text("えらいポイントを貯めて自分にご褒美！")
                .padding(5)
            
            // sample1
            
            HStack{
                Image(systemName: "star.fill")
                    .foregroundColor(Color.orange)
                Text("プリン")
                Spacer()
                Text("5ポイント")
            }.padding(5)
            
            //sample 2
            
            HStack{
                Image(systemName: "star.fill")
                    .foregroundColor(Color.orange)
                Text("大盛りパフェ")
                Spacer()
                Text("10ポイント")
            }.padding(5)
            
            Spacer()
        }
        .padding(10)
    }
}

struct GoalSheet_Previews: PreviewProvider {
    static var previews: some View {
        GoalSheet()
    }
}
