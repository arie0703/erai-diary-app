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
    
    func getTextFromDate(date: Date!) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy/MM/dd(EEE) HH:mm"
        return date == nil ? "" : formatter.string(from: date)
    }
    
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
            .padding(0.1)
            .foregroundColor(.black)
            Text(getTextFromDate(date: post.date ?? Date()))
            .font(.footnote)
                .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
            
            
            
            
        }
        .padding(15) //文字に対するpadding
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
            PostsEdit(post:post, content: post.content ?? "", detail: post.detail ?? "", rate: post.rate, date: post.date ?? Date())
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
