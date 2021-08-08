//
//  ContentView.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/28.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    //color これを変更したら、RewardSheetのListの背景色も変える。
    let red: Double = ColorSetting().red
    let green: Double = ColorSetting().green
    let blue: Double = ColorSetting().blue
    
    
    init() {
            // 背景色を指定
            UITabBar.appearance().barTintColor = UIColor(red: 255.0 / 255.0, green: 235.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
            UITabBar.appearance().unselectedItemTintColor = UIColor(red: 190.0 / 255.0, green: 155.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
        
                
    }
    
    var body: some View {
        
        TabView {
            ZStack {
                Color(red: red, green: green, blue: blue)
                    .edgesIgnoringSafeArea(.all)
                PostsList()
                    .environment(\.managedObjectContext, self.viewContext)
            }
            .tabItem {
                VStack {
                    Image(systemName: "pencil")
                    Text("えらいリスト")
                }
            }.tag(1)
            
            ZStack {
                Color(red: red, green: green, blue: blue)
                    .edgesIgnoringSafeArea(.all)
                RewardSheet()
                    .environment(\.managedObjectContext, self.viewContext)
            }
            .tabItem {
                VStack {
                    Image(systemName: "star.fill")
                    Text("ごほうび")
                }
            }.tag(2)
            
            ZStack {
                Color(red: red, green: green, blue: blue)
                    .edgesIgnoringSafeArea(.all)
                ChallengeList()
                    .environment(\.managedObjectContext, self.viewContext)
            }
            .tabItem {
                VStack {
                    Image(systemName: "person")
                    Text("チャレンジ")
                }
            }.tag(3)
            
            ZStack {
                Color(red: red, green: green, blue: blue)
                    .edgesIgnoringSafeArea(.all)
                MyPage()
                    .environment(\.managedObjectContext, self.viewContext)
            }
            .tabItem {
                VStack {
                    Image(systemName: "person")
                    Text("マイページ")
                }
            }.tag(4)
        }
        .accentColor(Color.orange)
        
    }
}
struct ContentView_Previews: PreviewProvider {
    
    static let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    static let context = container.viewContext
    
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, context)
    }
}
