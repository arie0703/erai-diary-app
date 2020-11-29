//
//  PostsList.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/29.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct PostsList: View {
    var body: some View {
        NavigationView{
            List(postsData, id: \.id){ posts in
                NavigationLink(destination: ContentView(posts: posts)){
                    PostsView(posts: posts)
                }
            }
            .navigationBarTitle(Text("タイムライン"))
        }
    }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        PostsList()
    }
}
