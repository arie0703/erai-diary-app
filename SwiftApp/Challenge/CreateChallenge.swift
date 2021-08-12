//
//  CreateChallenge.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/08/08.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI
import CoreData

struct CreateChallenge: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var showingAlert: Bool = false
    @State var title: String = ""
    @State var comment: String = ""
    @State var start_date: Date = Date()
    @State var end_date: Date = Date()
    @State var point_double: Double = 1 //スライダー用
    @State var goal_double: Double = 1
    @State var point: Int32 = 1
    @State var goal: Int32 = 1
    
    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    init(){
        //formの背景色を設定できるように
        UITableView.appearance().backgroundColor = .clear
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
                        VStack {
                            DatePicker("開始日時", selection: $start_date, displayedComponents: .date)
                                .accentColor(Color(red:0.58, green:0.4, blue: 0.29))
                                .padding(.bottom, 10)
                            DatePicker("終了日時", selection: $end_date, displayedComponents: .date)
                                .accentColor(Color(red:0.58, green:0.4, blue: 0.29))
                            
                            Text("チャレンジ期間は" + (calcDateRemainder(firstDate: end_date, secondDate: start_date) + 1).description + "日間です")
                            if calcDateRemainder(firstDate: end_date, secondDate: start_date) + 1 > 100 {
                                Text("設定できるチャレンジ期間は最大100日です。")
                                    .foregroundColor(.red)
                                    .padding(3)
                            } else if calcDateRemainder(firstDate: end_date, secondDate: start_date) + 1 < 3 {
                                Text("チャレンジ期間は最低3日以上に設定してください。")
                                    .foregroundColor(.red)
                                    .padding(3)
                            } else if start_date < Calendar(identifier: .gregorian).startOfDay(for: Date()) {
                                Text("開始日を本日より前に設定することはできません。")
                                    .foregroundColor(.red)
                                    .padding(3)
                            }
                        }
                    }
                    
                    
                    Section(header: Text("目標日数")){
                        VStack {
                            VStack {
                                Slider(value: $goal_double, in: 1...100, step: 1)
                                Stepper(value: $goal_double, in: 1...100) {
                                    Text("\(goal_double, specifier: "%.0f") 日")
                                }
                                if Int(goal_double) > calcDateRemainder(firstDate: self.end_date, secondDate: self.start_date) + 1 {
                                    Text("目標日数がチャレンジ期間を超えています")
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
                            if Int(goal_double) > calcDateRemainder(firstDate: self.end_date, secondDate: self.start_date) + 1 || // 目標日数がチャレンジ日数以上の時
                                calcDateRemainder(firstDate: self.end_date, secondDate: self.start_date) + 1 > 100 || // チャレンジ期間が100日以上
                                calcDateRemainder(firstDate: self.end_date, secondDate: self.start_date) + 1 < 3 ||// チャレンジ期間が３日未満
                                self.start_date < Calendar(identifier: .gregorian).startOfDay(for: Date()) // 開始日が今日より前
                            {
                                self.showingAlert = true
                            } else {
                                ChallengeEntity.create(in: self.viewContext,
                                title: self.title,
                                comment: self.comment,
                                start_date: self.start_date,
                                end_date: self.end_date,
                                created_at: Date(),
                                updated_at: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, //初期値は一日前の日付としておく
                                continuation_days: 0,
                                clear_days: 0,
                                goal: Int32(self.goal_double),
                                point: Int32(self.point_double),
                                isDone: false)
                                self.save()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("追加！")
                        }.alert(isPresented: self.$showingAlert) {
                            Alert(
                                  title: Text("エラー"),
                                  message: Text("登録内容にエラーがあります。")
                            )
                        }
                    }
                }
            )
            .navigationBarTitle("チャレンジを追加")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "trash")
                .foregroundColor(Color.red)
            })
        }
    }
    
}

