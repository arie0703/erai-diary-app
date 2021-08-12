//
//  PostsNew.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/29.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct PostsNew: View {
    @ObservedObject var user = UserProfile()
    
    @State var content: String = ""
    @State var detail: String = ""
    @State var date = Date()
    @State var showTemplate: Bool = false
    @State var showModal: Bool = false
    
    @State var showingAlert = false
    
    @Environment(\.managedObjectContext) var viewContext
    
    //モーダルの処理
    @Environment(\.presentationMode) var presentationMode
    
    fileprivate func save() {
        do {
            try  self.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //星の色　ボタンでチェンジ　デフォルトで星1は色がついてる
    @State var starColor1 = Color.orange
    @State var starColor2 = Color.gray
    @State var starColor3 = Color.gray
    
    @State var rate: Int32 = 1
    
    func changeStar() {
        if rate == 1 {
            starColor2 = Color.gray
            starColor3 = Color.gray
        } else if rate == 2 {
            starColor2 = Color.orange
            starColor3 = Color.gray
        } else {
            starColor2 = Color.orange
            starColor3 = Color.orange
        }
    }
    
    func messages(rate: Int) -> String {
        if rate == 1 {
            return "えらい！"
        } else if rate == 2 {
            return "すごくえらい！"
        } else {
            return "ウルトラえらい！"
        }
        
    }
    
    func shareOnTwitter(text: String) {

        let text = text
        let hashTag = "#私のえらい日記"
        let appUrl = "https://apps.apple.com/app/id1574659017"
        let completedText = text + "\n" + hashTag + "\n" + appUrl

        //作成したテキストをエンコード
        let encodedText = completedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        //エンコードしたテキストをURLに繋げ、URLを開いてツイート画面を表示させる
        if let encodedText = encodedText,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url)
        }
    }
    
    
    fileprivate func cancelPost() {
        self.detail = ""
    }
    
    let formRed: Double = ColorSetting().formRed
    let formGreen: Double = ColorSetting().formGreen
    let formBlue: Double = ColorSetting().formBlue
    
    var body: some View {
        ZStack {
            NavigationView {
                //背景色
                Color(red: formRed, green: formGreen, blue: formBlue)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    ScrollView{
                        VStack{
                            HStack {
                                
                                
                                Button(action: {
                                    self.showTemplate = true
                                    
                                }) {
                                    Text("テンプレートを使用")
                                        .foregroundColor(.orange)
                                }.sheet(isPresented: $showTemplate) {
                                    PostTemplate(content: $content, rate: $rate, starColor2: $starColor2, starColor3: $starColor3)
                                        .accentColor(Color.orange)
                                }.padding(.vertical)
                                
                                Button(action: {
                                    self.showModal = true
                                    
                                }) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }.padding(10)
                            
                            Text("今日あったえらい出来事")
                            TextField("例: 三食しっかり食べた！", text: $content)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 30)
                                .padding(.horizontal)
                            
                            Text("ひとこと")
                            TextField("", text: $detail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 30)
                                .padding(.horizontal)
                            
                            
                            
                            
                            
                            Text("えらい度")
                            VStack{
                                HStack{
                                    Spacer()
                                    
                                    Button(action: {
                                        self.rate = 1
                                        self.changeStar()
                                    }){
                                        Image(systemName: "star.fill")
                                        .foregroundColor(starColor1)
                                        .font(.title)
                                        .padding(10)
                                    }
                                
                                    Button(action: {
                                        self.rate = 2
                                        self.changeStar()
                                    }){
                                        Image(systemName: "star.fill")
                                        .foregroundColor(starColor2)
                                            .font(.title)
                                        .padding(10)
                                    }
                                
                                
                                    Button(action: {
                                        self.rate = 3
                                        self.changeStar()
                                    }){
                                        Image(systemName: "star.fill")
                                        .foregroundColor(starColor3)
                                        .font(.title)
                                        .padding(10)
                                    }
                                    
                                    
                                    Spacer()
                                }
                                
                                Text(messages(rate: Int(rate)))
                                
                                
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                            
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .resizable()
                                    .frame(width: 25.0, height: 25.0, alignment: .leading)
                                    .foregroundColor(Color(red:0.64, green:0.5, blue: 0.33))
                                DatePicker("日時", selection: $date)
                                    .labelsHidden()
                                    .accentColor(Color(red:0.58, green:0.4, blue: 0.29))
                            }
                            
                            
                            
                            Text("今日もお疲れ様！")
                            .padding(20)
                            
                            Group {
                                Button(action: {
                                    if self.content == "" { // バリデーション
                                        self.showingAlert = true
                                    } else {
                                        PostEntity.create(in: self.viewContext,
                                        content: self.content,
                                        detail: self.detail,
                                        rate: self.rate,
                                        date: self.date)
                                        self.save()
                                        UserDefaults.standard.set(self.user.point + Int(self.rate), forKey: "point")
                                        
                                        UserDefaults.standard.set(self.user.total_point + Int(self.rate), forKey: "total_point")
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }) {
                                    Text(" 投稿！ ")
                                    .foregroundColor(Color.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 60)
                                    .background(Color.orange)
                                    .cornerRadius(2)
                
                                }.padding(.bottom, 3)
                                
                                .alert(isPresented: self.$showingAlert) {
                                    Alert(
                                          title: Text("エラー"),
                                          message: Text("「今日あったえらい出来事」を入力してください。")
                                    )
                                }
                                Button(action: {
                                    shareOnTwitter(text: content)
                                }) {
                                    Text("Twitterでシェア")
                                        .foregroundColor(Color.blue)
                                        .fontWeight(.bold)
                                }.padding(20)
                            }
                            
                            
                            
                            
                        } // VStack
                        .onAppear{
                            if rate == 1 {
                                starColor2 = Color.gray
                                starColor3 = Color.gray
                            } else if rate == 2 {
                                starColor2 = Color.orange
                                starColor3 = Color.gray
                            } else {
                                starColor2 = Color.orange
                                starColor3 = Color.orange
                            }
                        }
                    }//Scroll View
                    
                )//.overlay
                
                
                .navigationBarTitle("記録する", displayMode: .inline)
                .navigationBarItems(trailing:
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Image(systemName: "trash")
                    .foregroundColor(Color.red)
                })
                
            }
            if showModal {
                AboutTemplate(isPresented: $showModal)
                    .accentColor(Color.orange)
            }
        
        }
        
    }
    
}

struct PostsNew_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
    .persistentContainer.viewContext
    static var previews: some View {
        PostsNew()
        .environment(\.managedObjectContext, context)
    }
}
