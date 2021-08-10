//
//  AboutChallenge.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/08/10.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct AboutChallenge: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 12) {
                Text("チャレンジとは").font(.title)
                    .padding(10)
                
                Text("特定の期間で継続的に物事に取り組むことを目指す機能です。")
                Text("例: 「100日間運動する!」「2ヶ月間で50回自炊する！」").font(.footnote)
                    .padding(.bottom, 10)
                Text("チャレンジ達成時に得られる「えらいポイント」を自身で設定することもできます。")

                
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }, label: {
                    Text("閉じる")
                })
            }
            .frame(width: 260, alignment: .center)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            
        }
        
    }
    
    
}
