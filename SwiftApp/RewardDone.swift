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
                 
            }
            .navigationBarTitle("過去のごほうび")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                .foregroundColor(Color.red)
            })

            
        }
        
        
    }
}

struct RewardDone_Previews: PreviewProvider {
    static var previews: some View {
        RewardDone()
    }
}
