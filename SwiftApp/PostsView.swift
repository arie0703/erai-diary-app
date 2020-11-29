//
//  PostsView.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/29.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct PostsView: View {
    var posts: Posts
    var body: some View {
        HStack{
            posts.image
                .resizable()
                .scaledToFit()
                .frame(width: 70.0, height: 70.0)
            Text(posts.content)
            Spacer()
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            PostsView(posts: postsData[0])
            PostsView(posts: postsData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
