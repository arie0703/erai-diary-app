//
//  PostsNew.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/29.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct PostsNew: View {
    
    @State var newPost: String = ""
    
    fileprivate func addNewPost() {
        self.newPost = ""
    }
    
    fileprivate func cancelPost() {
        self.newPost = ""
    }
    
    var body: some View {
        HStack{
            TextField("今日あったえらい出来事", text: $newPost){
                self.addNewPost()
            }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                self.addNewPost()
            }) {
                Text("Post")
            }
            
            Button(action: {
                self.cancelPost()
            }) {
                Text("Cancel")
                    .foregroundColor(Color.red)
            }
        }
    }
}

struct PostsNew_Previews: PreviewProvider {
    static var previews: some View {
        PostsNew()
    }
}
