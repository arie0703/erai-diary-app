//
//  ChallengeCard.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/08/07.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import Foundation


import SwiftUI

struct ChallengeCard: View {
    @ObservedObject var challenge: ChallengeEntity
    @Environment(\.managedObjectContext) var viewContext
    @State var showingAlert: Bool = false
    
    var start_of_today: Date = Calendar(identifier: .gregorian).startOfDay(for: Date())
    var end_of_today: Date = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
    
    var date: Date = Date()
    var date2: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    func isContinual(date: Date) -> Bool {
        //challenge.updated_date (最後に達成報告された日付)の0時0分と23時59分を取得
        let start_of_date = Calendar(identifier: .gregorian).startOfDay(for: date)
        let end_of_date = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        if yesterday >= start_of_date && yesterday <= end_of_date {
            return true
        } else {
            return false
        }
    }

    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    var body: some View {
        VStack {
            Text(challenge.title ?? "")
                .font(.title)
            Text(challenge.comment ?? "")
                .padding(.bottom, 10)
            if Date() >= challenge.start_date ?? Date() && Date() <= challenge.end_date ?? Date() {
                Text("達成日数")
                Text(challenge.clear_days.description + "/" + challenge.goal.description).font(.title)
                Text(challenge.continuation_days.description + "日継続中！")
                    .padding(.bottom, 10)
                Text(challenge.created_at!.description)
                Text(challenge.updated_at!.description)
            } else {
                Text("開始前だよ")
                    .padding(.bottom, 10)
            }
            
            if challenge.updated_at! < start_of_today  {
                //今日中に達成報告されていなかったら、達成報告ボタンを出す
            
                Button(action: {
                    self.showingAlert = true
                }) {
                    Text("Done!").foregroundColor(.red)
                }.alert(isPresented: self.$showingAlert) {
                    Alert(
                          title: Text("達成報告"),
                          message: Text("完了済みにしますか？"),
                          primaryButton: .cancel(Text("キャンセル")),
                          secondaryButton: .default(Text("はい"),
                          action:
                          {
                            if isContinual(date: challenge.updated_at!) == true {
                                challenge.continuation_days += 1
                            } else {
                                challenge.continuation_days = 0
                            }
                            challenge.clear_days += 1
                            challenge.updated_at = Date()
                            self.save()
                          })
                    )
                }
            } else {
                Text("今日は達成済み！")
            }
            
            Spacer()
            
        }.padding(50)
        .background(Color.orange)
        .cornerRadius(12.0)
    }
}

struct ChallengeCard_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
    .persistentContainer.viewContext
    static var previews: some View {
        let newChallenge = ChallengeEntity(context: context)
        ChallengeCard(challenge: newChallenge)
    }
}
