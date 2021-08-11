//
//  ChallengeList.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/08/07.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData

struct ChallengeList: View {
    @Environment(\.managedObjectContext) var viewContext
    @State var showCreateView = false
    @State var showDoneList = false
    @State var showModal = false
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \ChallengeEntity.created_at,
                                       ascending: false)],
    predicate: NSPredicate(format:"isDone == false"),
    animation: .default)
    
    var challenges: FetchedResults<ChallengeEntity>
    
    let red: Double = ColorSetting().red
    let green: Double = ColorSetting().green
    let blue: Double = ColorSetting().blue
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("チャレンジ(β版)").font(.title)
                Button(action: {
                    self.showModal = true
                    
                }) {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Button(action: {
                    self.showDoneList = true
                }) {
                    Text("履歴")
                }.sheet(isPresented: $showDoneList) {

                    ChallengeDone().environment(\.managedObjectContext, self.viewContext)
                        .accentColor(Color.orange)
                    
                }
                
                Button(action: {
                    self.showCreateView = true
                }) {
                    Image(systemName: "plus")
                    .font(.title)
                }.sheet(isPresented: $showCreateView) {
                    CreateChallenge().environment(\.managedObjectContext, self.viewContext)
                        .accentColor(Color.orange)
                }
            }
            Text("色々なことの継続にチャレンジ！")
                .padding(10)
            
            if challenges.count > 1 {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(challenges){ challenge in
                            ChallengeCard(challenge: challenge)
                        }
                    }
                }
            } else if challenges.count == 1 {
                ChallengeCard(challenge: challenges[0])
            } else {
                Text("まだチャレンジはありません").foregroundColor(.gray).padding(5)
            }
            
            Spacer()
            
        }.padding(10)
        
        if showModal {
            AboutChallenge(isPresented: $showModal)
                .accentColor(Color.orange)
        }
        
    }
}

struct ChallengeList_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeList()
    }
}
