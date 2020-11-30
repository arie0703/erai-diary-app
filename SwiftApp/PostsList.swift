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
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.id,
                                       ascending: true)],
    animation: .default)
    
    private var postList: FetchedResults<PostEntity>
    
    var body: some View {
        VStack {
            List {
                ForEach(postList) { post in
                        Text(post.content ?? "no title")
                        Text(post.detail ?? "no title")
                }
            }
            PostsNew()
                .padding()
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
                     content: "筋トレをした！", detail: "腹筋10回")
    PostEntity.create(in: context,
    content: "筋トレをした！!", detail: "腹筋10回!")
    PostEntity.create(in: context,
    content: "筋トレをした！!!", detail: "腹筋10回!!")
    PostEntity.create(in: context,
    content: "筋トレをした！!!", detail: "腹筋10回!")
        return PostsList()
            .environment(\.managedObjectContext, context)
            
        
    }
}
