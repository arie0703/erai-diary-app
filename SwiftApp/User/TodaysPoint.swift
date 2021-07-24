//
//  TodaysPoint.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/07/24.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import CoreData
import SwiftUI



struct TodaysPoint: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State var tex = "aa"
    @State var sum: Int = 0
    
    func start_of_date() -> Date {
        let start_of_date = Calendar(identifier: .gregorian).startOfDay(for: Date())

        return start_of_date
    }

    func end_of_date() -> Date {
        let end_of_date = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        return end_of_date
    }
    
    //今日の獲得えらいポイント表示
    func todaysPointSum(in managedObjectContext: NSManagedObjectContext) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        //今日の初めから終わりまでの投稿を取得
        fetchRequest.predicate = NSPredicate(format:"date BETWEEN {%@ , %@}", start_of_date() as NSDate, end_of_date() as NSDate)
        //取得するデータ名はsumとする
        let expressionName = "sum"
        //rateの値をとる
        let keyPathExpression = NSExpression(forKeyPath: "rate")
        //ここで取ってきたデータのrateの合計値を算出する。
        let expression = NSExpression(forFunction: "sum:", arguments: [keyPathExpression])
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = expressionName
        expressionDescription.expression = expression
        expressionDescription.expressionResultType = NSAttributeType.integer32AttributeType
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest).first
            let result = results as! Dictionary<String, Int>
            let sum = result[expressionName]
            return sum ?? 0
                
        } catch  {
            print("Error: \(error.localizedDescription)")
            return 0
        }
    }
    

    
    
    
    
    var body: some View {
        VStack {
            Text("今日は" + todaysPointSum(in: viewContext).description + "ポイント獲得しました！")
        }.padding()
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red:0.95, green:0.75, blue: 0.48), lineWidth: 2)
        )
    }
}

struct TodaysPoint_Previews: PreviewProvider {
    static let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    static let context = container.viewContext
    
    static var previews: some View {
        // テストデータの全削除
    let request = NSBatchDeleteRequest(
       fetchRequest: NSFetchRequest(entityName: "PostEntity"))
    try! container.persistentStoreCoordinator.execute(request, with: context)
        
    // データを追加
    PostEntity.create(in: context,
                      content: "tes", detail: "tes", rate: 3, date: Date())
    PostEntity.create(in: context,
                      content: "tes", detail: "tes", rate: 3, date: Date())
    PostEntity.create(in: context,
                      content: "tes", detail: "tes", rate: 3, date: Date())
    PostEntity.create(in: context,
                      content: "tes", detail: "tes", rate: 3, date: Date())
        return TodaysPoint()
            .environment(\.managedObjectContext, context)
            
        
    }
}
