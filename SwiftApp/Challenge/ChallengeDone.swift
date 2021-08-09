//
//  ChallengeDone.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/08/09.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct ChallengeDone: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    //モーダルの処理
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \ChallengeEntity.created_at,
                                       ascending: false)],
    predicate: NSPredicate(format:"isDone == true"),
    animation: .default)
    
    var challenges: FetchedResults<ChallengeEntity>
    
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
            viewContext.delete(challenges[index])
        }
        do {
            try viewContext.save()
        } catch {
            fatalError()
        }
    }
    
    let red: Double = ColorSetting().red
    let green: Double = ColorSetting().green
    let blue: Double = ColorSetting().blue
    
    var body: some View {
        NavigationView {
            List {
                ForEach(challenges){ challenge in
                    VStack{
                        Text(challenge.title ?? "").font(.title)
                        Text(challenge.comment ?? "")
                        Text("達成状況")
                        Text(challenge.clear_days.description + "/" + challenge.goal.description + "日達成")
                        
                        
                    }
                    .padding(5)
                    .listRowBackground(Color(red: red, green: green, blue: blue))
                }
                .onDelete{ indexSet in
                    self.remove(indexSet: indexSet)
                }
                 
            }
            .navigationBarTitle("チャレンジ履歴")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                .foregroundColor(Color.gray)
            })

            
        }
        
        
    }
}
