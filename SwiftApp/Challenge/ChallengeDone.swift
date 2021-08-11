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
    @State var showDetail = false
    
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
            ZStack {
                Color(red: red, green: green, blue: blue)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("終了済みのチャレンジを表示します。").padding(15)
                    
                    if challenges.count > 1 {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(challenges){ challenge in
                                    ChallengeCard(challenge: challenge)
                                }
                            }.padding(10)
                        }
                    } else if challenges.count == 1 {
                        ChallengeCard(challenge: challenges[0])
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("チャレンジ履歴", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                .foregroundColor(Color.gray)
            })
            
            

            
        }
        
        
        
    }
}
