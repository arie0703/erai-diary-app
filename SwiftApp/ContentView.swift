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
    
    var body: some View {
        TabView {
            PostsList()
                .environment(\.managedObjectContext, self.viewContext)
                .tabItem {
                    VStack {
                        Image(systemName: "pencil")
                        Text("タイムライン")
                    }
            }.tag(1)
            GoalSheet()
                .environment(\.managedObjectContext, self.viewContext)
                .tabItem {
                    VStack {
                        Image(systemName: "star.fill")
                        Text("ごほうび")
                    }
            }.tag(2)
            MyPage()
                .environment(\.managedObjectContext, self.viewContext)
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("マイページ")
                    }
            }.tag(3)
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
