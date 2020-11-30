//
//  ContentView.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/28.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var posts: Posts
    var body: some View {
        VStack(alignment: .leading){
            Text(posts.content)
                .font(.title)
                .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                
            Text("detail.")
            .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                
            CircleImage(image: posts.image)
            
        }
        .padding()
        .background(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
        
        
    
        
        
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(posts: postsData[0])
    }
}
