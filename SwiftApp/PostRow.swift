//
//  PostRow.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/30.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct PostRow: View {
    @ObservedObject var post: PostEntity
    var body: some View {
        HStack{
            Text(self.post.content ?? "no title")
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
        let newPost = PostEntity(context: context)
        
        let newPost1 = PostEntity(context: context)
        newPost1.content="クレームへの対応"
        
        let newPost2 = PostEntity(context: context)
        newPost2.content="クレームへの対応"
        
    
        return VStack(alignment: .leading) {
            VStack {
                PostRow(post: newPost)
                PostRow(post: newPost1)
                PostRow(post: newPost2)
            }.environment(\.managedObjectContext, context)
        }
    }
}
