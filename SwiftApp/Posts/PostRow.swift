//
//  PostRow.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/02/11.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct PostRow: View {
    @ObservedObject var post: PostEntity
    @State var editPost = false
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        Button(action: {
           self.editPost = true
        }) {
        VStack(alignment: .leading){
            HStack {
                Text(post.content ?? "no title")
                    .foregroundColor(.black)
                    .font(.title)
                Spacer()
                Group {
                    Image(systemName: "star.fill")
                    Text(post.rate.description)
                }.foregroundColor(.orange)
                
            }
            
                
            
            Text(post.detail ?? "no title")
            .foregroundColor(.black)
            
            
            
            
        }
        .padding(20) //文字に対するpadding
        .frame(maxWidth: .infinity, minHeight: 100)
            .background(Color(red: 1, green: 0.87, blue: 0.62))
        .cornerRadius(10)
        .padding(EdgeInsets(
            top: 2,
            leading: 6,
            bottom: 2,
            trailing: 6
        ))
            
        }.sheet(isPresented: self.$editPost) {
            PostsEdit(post:post)
                .environment(\.managedObjectContext, self.viewContext)
        }
        
    }
}

struct PostRow_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
    .persistentContainer.viewContext
    static var previews: some View {
        let newPost = PostEntity(context: context)
        PostRow(post: newPost)
            .environment(\.managedObjectContext, context)
    }
}
