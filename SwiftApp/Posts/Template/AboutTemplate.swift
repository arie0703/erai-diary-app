//
//  aboutTemplate.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/08/06.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData

struct AboutTemplate: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 12) {
                        Text("テンプレート機能って？")
                        
                        Text("よく記録する内容を保存しておくことができます。")
                            
                        Text("例: 「ジョギング3キロ」, 「英語の勉強」")
                            .font(.footnote)
                        
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
