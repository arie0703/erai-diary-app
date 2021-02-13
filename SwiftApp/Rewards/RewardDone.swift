//
//  RewardDone.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/02/08.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct RewardDone: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    //モーダルの処理
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \RewardEntity.point,
                                       ascending: true)],
    predicate: NSPredicate(format:"isDone == true"),
    animation: .default)
    
    var rewardList: FetchedResults<RewardEntity>
    
    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func remove(indexSet: IndexSet) {
        for index in indexSet {
            viewContext.delete(rewardList[index])
        }
        do {
            try viewContext.save()
        } catch {
            fatalError()
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(rewardList){ reward in
                    HStack{
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.orange)
                        Text(reward.content ?? "no title")
                        Spacer()
                        Text(reward.point.description + " P")
                    }
                    .padding(5)
                }
                .onDelete{ indexSet in
                    self.remove(indexSet: indexSet)
                }
                 
            }
            .navigationBarTitle("過去のごほうび")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                .foregroundColor(Color.gray)
            })

            
        }
        
        
    }
}

struct RewardDone_Previews: PreviewProvider {
    static var previews: some View {
        RewardDone()
    }
}
