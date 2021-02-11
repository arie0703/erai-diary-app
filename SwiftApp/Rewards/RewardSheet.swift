//
//  GoalSheet.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/02.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData

struct RewardSheet: View {
    @ObservedObject var user = UserProfile()
    @Environment(\.managedObjectContext) var viewContext
    
    @State var showDones = false
    @State var addNewReward = false
    
    @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \RewardEntity.point,
                                       ascending: true)],
    predicate: NSPredicate(format:"isDone == false"),
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
        VStack(alignment: .leading){
            HStack{
                Text("ごほうびシート")
                .font(.title)
                
                
                Button(action: {
                    self.showDones = true
                }) {
                    Text("履歴")
                }.sheet(isPresented: $showDones) {
                    RewardDone()
                        .environment(\.managedObjectContext, self.viewContext)
                }
                
                Spacer()
                
                Button(action: {
                    self.addNewReward = true
                }) {
                    Image(systemName: "plus")
                    .font(.title)
                }.sheet(isPresented: $addNewReward) {
                    RewardNew()
                        .environment(\.managedObjectContext, self.viewContext)
                }
            }
            
            Text("えらいポイントを貯めて自分にご褒美！")
                .padding(5)
            
            List {
                ForEach(rewardList){ reward in
                    
                    // ご褒美シート
                    RewardRow(reward: reward)
                    
                    
                }
                
                .onDelete{ indexSet in
                    self.remove(indexSet: indexSet)
                }
                 
            }
            
            Spacer()
        }
        .padding(10)
    }
}

struct RewardSheet_Previews: PreviewProvider {
    static let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    static let context = container.viewContext
    
    static var previews: some View {
    
    let request = NSBatchDeleteRequest(
       fetchRequest: NSFetchRequest(entityName: "RewardEntity"))
    try! container.persistentStoreCoordinator.execute(request, with: context)
        
    // データを追加
    RewardEntity.create(in: context,
                     content: "プリン", point: 5, isDone: false)
    RewardEntity.create(in: context,
                        content: "大盛りパフェ", point: 10, isDone: false)
    RewardEntity.create(in: context,
                        content: "焼肉", point: 15, isDone: true)
        return RewardSheet()
            .environment(\.managedObjectContext, context)
            
        
    }
}
