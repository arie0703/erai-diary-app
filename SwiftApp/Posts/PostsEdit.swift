//
//  PostsEdit.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/12/15.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//
import SwiftUI

struct PostsEdit: View {
    @ObservedObject var user = UserProfile()
    @ObservedObject var post: PostEntity
    @State var content: String
    @State var detail: String
    @State var rate: Int32
    @State var date: Date
    
    @State var showingAlert = false
    
    @State var showingSheet = false
    
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
    
    fileprivate func delete() {
        viewContext.delete(post)
        save()
    }
    
    //星の色　ボタンでチェンジ　デフォルトで星1は色がついてる
    @State var starColor1 = Color.orange
    @State var starColor2 = Color.gray
    @State var starColor3 = Color.gray
    
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
    
    func getDate(date: Date!) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return date == nil ? "" : formatter.string(from: date)
    }
    
    let formRed: Double = ColorSetting().formRed
    let formGreen: Double = ColorSetting().formGreen
    let formBlue: Double = ColorSetting().formBlue
    
    let red: Double = ColorSetting().red
    let green: Double = ColorSetting().green
    let blue: Double = ColorSetting().blue
    
    
    var body: some View {
        NavigationView {
            Color(red: formRed, green: formGreen, blue: formBlue)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ScrollView{
                    VStack{
                        Text("今日あったえらい出来事")
                        TextField("例: 三食しっかり食べた！", text: $content)
                            .background(Color(red: red, green: green, blue: blue))
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
                                }.onAppear{changeStar()}//編集画面が開かれたときに、星の状態が編集対象データのえらい度を反映するようにする
                                
                                
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
                            DatePicker("日時", selection: $date)  //$post.dateだとBinding<Date>?型になってしまう
                                .labelsHidden()
                                .accentColor(Color(red:0.58, green:0.4, blue: 0.29))
                        }.padding(.bottom, 30)
                
                        Group {
                        
                            Button(action: {
                                if self.content == "" {
                                    self.showingAlert = true
                                } else {
                                    if(self.user.point +  (Int(self.rate) - Int(self.post.rate)) < 0) {
                                        UserDefaults.standard.set(0 , forKey: "point")
                                    } else {
                                    UserDefaults.standard.set(self.user.point +  (Int(self.rate) - Int(self.post.rate)) , forKey: "point")
                                    }
                                    
                                    if(self.user.total_point +  (Int(self.rate) - Int(self.post.rate)) < 0) {
                                        UserDefaults.standard.set(0 , forKey: "total_point")
                                    } else {
                                        UserDefaults.standard.set(self.user.total_point + (Int(self.rate) - Int(self.post.rate)), forKey: "total_point")
                                    }
                                    
                                    self.post.content = self.content
                                    self.post.detail = self.detail
                                    self.post.date = self.date
                                    //avoidMinusPoint(point: Int32(UserProfile().point)) //　投稿削除・編集などによりえらいポイントが負の数になるのを防ぐ
                                    self.post.rate = self.rate
                                    self.save()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                Text("編集")
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 73)
                                    .background(Color.orange)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(2)
                            }.alert(isPresented: self.$showingAlert) {
                                Alert(
                                      title: Text("エラー"),
                                      message: Text("「今日あったえらい出来事」を入力してください。")
                                )
                            }
                            
                            Button(action:{
                                shareOnTwitter(text: content)
                            }) {
                                Text("Twitterでシェア")
                                    .foregroundColor(Color.blue)
                                    .fontWeight(.bold)
                            }.padding(15)
                            Spacer(minLength: 15)
                            
                            Button(action: {
                                self.showingSheet = true
                            }) {
                                Text("削除")
                                    .foregroundColor(Color.red)
                            }.padding(.bottom, 10)
                        }
                        

                            
                        
                        
                    }//VStack
                }//ScrollView
            )//背景色
            .navigationBarTitle("編集する")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "trash")
                .foregroundColor(Color.red)
            })
            
            .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("投稿を削除"), message: Text("この投稿を削除します。よろしいですか？"), buttons: [
                .destructive(Text("削除")) {
                    
                    //avoidMinusPoint(point: Int32(UserProfile().point))
                    //　投稿削除・編集などによりえらいポイントが負の数になるのを防ぐ
                    if(self.user.point - Int(self.post.rate) < 0) {
                        UserDefaults.standard.set(0 , forKey: "point")
                    } else {
                        UserDefaults.standard.set(self.user.point - Int(self.post.rate) , forKey: "point")
                    }
                    if(self.user.total_point - Int(self.post.rate) < 0) {
                        UserDefaults.standard.set(0 , forKey: "total_point")
                    } else {
                        UserDefaults.standard.set(self.user.total_point - Int(self.post.rate), forKey: "total_point")
                    }
                    self.delete()
                    self.presentationMode.wrappedValue.dismiss()
                },
                .cancel(Text("キャンセル"))
            
            ])
            }
        }
    }
}

struct PostsEdit_Previews: PreviewProvider {
    static let context = (UIApplication.shared.delegate as! AppDelegate)
    .persistentContainer.viewContext
    static var previews: some View {
        let newPost = PostEntity(context: context)
        return NavigationView {
            PostsEdit(post: newPost, content: "preview", detail: "test", rate: 1, date: Date())
            .environment(\.managedObjectContext, context)
        }
    }
}
