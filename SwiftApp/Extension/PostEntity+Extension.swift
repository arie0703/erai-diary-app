import CoreData
import SwiftUI

extension PostEntity: Identifiable{}
extension PostEntity {
    
    static func create(in managedObjectContext: NSManagedObjectContext,
                       content: String,
                       detail: String,
                       date: Date? = Date()){
        let post = self.init(context: managedObjectContext)
        
        print(content)
        print(detail)
        post.detail = detail
        post.content = content
        post.id = UUID().uuidString
        post.date = date
        
        do {
            try  managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // データ個数を取得するメソッド
    
    static func count(in managedObjectContext: NSManagedObjectContext) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        
        
        do {
            let count = try managedObjectContext.count(for: fetchRequest)
            return count
        } catch  {
            print("Error: \(error.localizedDescription)")
            return 0
        }
    }
}
