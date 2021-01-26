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
    
    @State var rate: Int = 1
    
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
    
    
    var body: some View {
        NavigationView {
            Color(red: 0.95, green: 0.95, blue: 0.95)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack{
                    Text("今日あったえらい出来事")
                    TextField("例: 三食しっかり食べた！", text: Binding($post.content, "content"))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 30)
                        .padding(.horizontal)
                
                    Text("ひとこと")
                    TextField("", text: Binding($post.detail, "detail"))
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
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 30)
                    
            
                    
                        
                
                
                        Button(action: {
                            self.save()
                            UserDefaults.standard.set(self.user.point + self.rate, forKey: "point")
                            
                            UserDefaults.standard.set(self.user.total_point + self.rate, forKey: "total_point")
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("編集")
                            .foregroundColor(Color.white)
                            .padding()
                            .padding(.horizontal, 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }.padding(.bottom)
                        
                        Button(action: {
                            self.showingSheet = true
                        }) {
                            Text("削除")
                            .foregroundColor(Color.white)
                            .padding()
                            .padding(.horizontal, 50)
                            .background(Color.red)
                            .cornerRadius(10)
                        }
                        
                    
                    
                }
            )//背景色
            .navigationBarTitle("編集する")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "trash")
                .foregroundColor(Color.red)
            })
            
            .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("タスクの削除"), message: Text("このタスクを削除します。よろしいですか？"), buttons: [
                .destructive(Text("削除")) {
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
            PostsEdit(post: newPost)
            .environment(\.managedObjectContext, context)
        }
    }
}
