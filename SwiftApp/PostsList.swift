//
//  PostsList.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/29.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData

struct PostsList: View {
    @Environment(\.managedObjectContext) var viewContext
    @State var addNewPost = false
    @State var editPost = false
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.date,
                                       ascending: false)],
    animation: .default)
    
    var postList: FetchedResults<PostEntity>
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("タイムライン")
                .font(.title)
                
                Spacer()
                Button(action: {
                    self.addNewPost = true
                }) {
                    Image(systemName: "plus")
                    .font(.title)
                }.sheet(isPresented: $addNewPost) {
                    PostsNew()
                        .environment(\.managedObjectContext, self.viewContext)
                }
                

            }
            .padding(10)
            
            ScrollView(.vertical, showsIndicators: false){
                ForEach(postList, id: \.self){ post in
                    
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
                    .padding(8) //要素間の空白
                        
                    }.sheet(isPresented: self.$editPost) {
                        PostsEdit(post:post)
                            .environment(\.managedObjectContext, self.viewContext)
                    }
                    
                }
            }
            
            
        }
        
    }

        
}

struct PostsList_Previews: PreviewProvider {
    

    static let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    static let context = container.viewContext
    
    static var previews: some View {
        // テストデータの全削除
    let request = NSBatchDeleteRequest(
       fetchRequest: NSFetchRequest(entityName: "PostEntity"))
    try! container.persistentStoreCoordinator.execute(request, with: context)
        
    // データを追加
    PostEntity.create(in: context,
                     content: "筋トレをした！", detail: "腹筋10回", rate: 3)
    PostEntity.create(in: context,
    content: "バイトをした！!", detail: "一万円稼いだ", rate: 3)
    PostEntity.create(in: context,
                      content: "運動した", detail: "ちょっと歩いた", rate: 3)
    PostEntity.create(in: context,
    content: "勉強した！", detail: "英検一級合格まで頑張ろう", rate: 3)
        return PostsList()
            .environment(\.managedObjectContext, context)
            
        
    }
}
