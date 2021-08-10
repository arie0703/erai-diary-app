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
    @ObservedObject var user = UserProfile()
    @Environment(\.managedObjectContext) var viewContext
    @State var showingAlert: Bool = false
    @State var showingEdit: Bool = false
    
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
    
    func getTextFromDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
    

    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    let brown: Color = Color(red:0.58, green:0.4, blue: 0.29)
    let darkbrown: Color = Color(red:0.29, green:0.2, blue: 0.15)
    
    
    var body: some View {
        VStack {
            HStack { // 右上に設定ボタン
                Spacer()
                Button(action: {
                    self.showingEdit = true
                }) {
                    Image(systemName: "gearshape.fill").foregroundColor(brown)
                }.sheet(isPresented: $showingEdit) {
                    EditChallenge(challenge: challenge, title: challenge.title ?? "", comment: challenge.comment ?? "", start_date: challenge.start_date!, end_date: challenge.end_date!, point_double: Double(challenge.point), goal_double: Double(challenge.goal))
                }
                
            }
            Group {
                Text(challenge.title ?? "") // title
                    .font(.title)
                    .padding(.bottom, 2)
                    
                Text(challenge.comment ?? "") // comment
                    .padding(.bottom, 3)
            }.foregroundColor(darkbrown)
            
            HStack { //チャレンジ期間
                Group {
                    Image(systemName: "calendar")
                    Text(getTextFromDate(date: challenge.start_date!) +  "~" + getTextFromDate(date: challenge.end_date!))
                        
                }.foregroundColor(darkbrown)
            }.padding(.bottom, 10)
            
            if Date() >= challenge.start_date ?? Date() && Date() <= challenge.end_date ?? Date() {
                
                Group {
                
                    Text(challenge.clear_days.description + "/" + challenge.goal.description).font(.title)
                    Text(challenge.continuation_days.description + "日継続中！")
                        .padding(.bottom, 10)
                }.foregroundColor(darkbrown)
                
                if challenge.updated_at! < start_of_today  {
                    //今日中に達成報告されていなかったら、達成報告ボタンを出す
                
                    Button(action: {
                        self.showingAlert = true
                    }) {
                        Text("Done!")
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
                                if challenge.clear_days == challenge.goal { // 目標達成判定
                                    challenge.isDone = true
                                    UserDefaults.standard.set(self.user.point + Int(challenge.point), forKey: "point") //ポイント加算処理
                                }
                                self.save()
                              })
                        )
                    }
                    
                } else {
                    Text("今日は達成済み！")
                        .foregroundColor(darkbrown)
                }
                
                
            } else {
                Text("開始前だよ")
                    .foregroundColor(darkbrown)
                    .padding(.bottom, 10)
            }
            
            Spacer()
            
        }.padding(10)
        .frame(width: 250, height: 300)
        .background(Color(red: 1, green: 0.82, blue: 0.58))
        .cornerRadius(12.0)
        .onAppear {
            if Calendar(identifier: .gregorian).startOfDay(for: Date()) > challenge.end_date! // もうチャレンジ期間を過ぎていたら
            {
                challenge.isDone = true // おしまい
                self.save()
            }
        }
        
        
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
