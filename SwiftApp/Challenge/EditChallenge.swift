//
//  EditChallenge.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/08/09.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//
import SwiftUI
import CoreData

struct EditChallenge: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var challenge: ChallengeEntity
    @State var showingAlert: Bool = false
    @State var title: String
    @State var comment: String
    @State var start_date: Date
    @State var end_date: Date
    @State var point_double: Double//スライダー用
    @State var goal_double: Double
    @State var clear_days: Int32
    @State var point: Int32 = 1
    @State var goal: Int32 = 1
    
    @State var showingDeleteAlert = false
    
    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    fileprivate func delete() {
        viewContext.delete(challenge)
        save()
    }
    
    
    let formRed: Double = ColorSetting().formRed
    let formGreen: Double = ColorSetting().formGreen
    let formBlue: Double = ColorSetting().formBlue
    
    func resetTime(date: Date) -> Date {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        components.hour = 0
        components.minute = 0
        components.second = 0

        return calendar.date(from: components)!
    }
    
    //二つの日付の差分を取得する関数
    func calcDateRemainder(firstDate: Date, secondDate: Date? = nil) -> Int{

        var retInterval:Double!
        let firstDateReset = resetTime(date: firstDate)

        if secondDate == nil {
            let nowDate: Date = Date()
            let nowDateReset = resetTime(date: nowDate)
            retInterval = firstDateReset.timeIntervalSince(nowDateReset)
        } else {
            let secondDateReset: Date = resetTime(date: secondDate!)
            retInterval = firstDate.timeIntervalSince(secondDateReset)
        }

        let ret = retInterval/86400

        return Int(floor(ret))  // n日
    }
    
    
    var body: some View {
        NavigationView {
            Color(red: formRed, green: formGreen, blue: formBlue)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                Form{
                    Section(header: Text("チャレンジタイトル")){
                        TextField("例：100日間ジョギング", text: $title)
                    }
                    Section(header: Text("コメント")){
                        TextField("", text: $comment)
                    }
                    Section(header: Text("チャレンジ期間")) {
                        VStack(alignment: .leading) {
                            Text("チャレンジ期間は" + (calcDateRemainder(firstDate: end_date, secondDate: start_date) + 1).description + "日間です")
                            Text("(残り" + (calcDateRemainder(firstDate: end_date, secondDate: Date()) + 1).description + "日)")
                            Text("※チャレンジ期間は途中で変更できません").font(.footnote)
                        }
                    }
                    
                    
                    Section(header: Text("目標日数")){
                        VStack {
                            VStack {
                                Slider(value: $goal_double, in: 1...100, step: 1)
                                Stepper(value: $goal_double, in: 1...100) {
                                    Text("\(goal_double, specifier: "%.0f") 日")
                                }
                                if Int(goal_double) > calcDateRemainder(firstDate: end_date, secondDate: start_date) + 1 {
                                    Text("目標日数がチャレンジ期間を超えています")
                                        .foregroundColor(.red)
                                        .padding(3)
                                }
                                if Int(clear_days) > Int(goal_double) {
                                    Text("目標日数が既に達成した日数を下回っています")
                                        .foregroundColor(.red)
                                        .padding(3)
                                }
                            }
                        }
                    }
                    Section(header: Text("クリア時の獲得ポイント")){
                        VStack {
                            Slider(value: $point_double, in: 1...100, step: 1)
                            Stepper(value: $point_double, in: 1...100) {
                                Text("\(point_double, specifier: "%.0f") ポイント")
                            }
                            
                        }
                    }
                    
                    
                    
                    
                    
                
                    Section{
                        Button(action: {
                            if Int(goal_double) > calcDateRemainder(firstDate: end_date, secondDate: start_date) + 1 || // 目標日数がチャレンジ日数以上の時
                                calcDateRemainder(firstDate: self.end_date, secondDate: self.start_date) + 1 > 100 || // チャレンジ期間が100日以上
                                calcDateRemainder(firstDate: self.end_date, secondDate: self.start_date) + 1 < 3 || // チャレンジ期間が３日未満
                                Int(clear_days) > Int(goal_double) // 目標日数が既に達成した日数を下回っている場合
                            {
                                self.showingAlert = true
                            } else {
                                
                                self.challenge.title = self.title
                                self.challenge.comment = self.comment
                                self.challenge.goal = Int32(self.goal_double)
                                self.challenge.point = Int32(self.point_double)
                                self.save()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("編集")
                        }.alert(isPresented: self.$showingAlert) {
                            Alert(
                                  title: Text("エラー"),
                                  message: Text("登録内容にエラーがあります。")
                            )
                        }
                    }
                    
                    Section {
                        Button(action: {
                            self.showingDeleteAlert = true
                        }) {
                            Text("削除")
                        }
                    }
                }
            )
            .navigationBarTitle("チャレンジを編集")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "trash")
                .foregroundColor(Color.red)
            })
            
            .actionSheet(isPresented: $showingDeleteAlert) {
            ActionSheet(title: Text("チャレンジを削除"), message: Text("このチャレンジを削除します。よろしいですか？"), buttons: [
                .destructive(Text("削除")) {
                    self.delete()
                    self.presentationMode.wrappedValue.dismiss()
                },
                .cancel(Text("キャンセル"))
            
            ])
            }
        }.onAppear {
            UITableView.appearance().backgroundColor = .clear
        }
    }
    
}

