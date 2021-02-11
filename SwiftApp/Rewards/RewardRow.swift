//
//  RewardRow.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/02/11.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct RewardRow: View {
    @ObservedObject var reward: RewardEntity
    @ObservedObject var user = UserProfile()
    @Environment(\.managedObjectContext) var viewContext
    //アラート表示用プロパティ
    @State private var showingAlert = false
    
    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    var body: some View {
        Button(action: {
            if UserProfile().point >= reward.point {
                self.showingAlert = true
            } else {
                print("ポイントが足りません")
            }
        }) {
            HStack{
                //ポイントが足りているときは、星の色がオレンジになる。
                if UserProfile().point >= reward.point {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.orange)
                } else {
                    Image(systemName: "star")
                    .foregroundColor(Color.orange)
                }
                Text(reward.content ?? "no title")
                Spacer()
                Text(reward.point.description + " P")
            }
            .padding(5)
        }
        .alert(isPresented: self.$showingAlert) {
                Alert(
                      title: Text("ごほうび"),
                      message: Text("ごほうびを使いますか？"),
                      primaryButton: .cancel(Text("キャンセル")),
                      secondaryButton: .default(Text("はい"),
                      action:
                      {
                        UserDefaults.standard.set(self.user.point - Int(reward.point), forKey: "point")
                        reward.isDone = true
                        self.save()
                      })
                )
        }
    }
}

struct RewardRow_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
    .persistentContainer.viewContext
    static var previews: some View {
        let newReward = RewardEntity(context: context)
        RewardRow(reward: newReward)
    }
}
