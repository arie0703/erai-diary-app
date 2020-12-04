import CoreData
import SwiftUI

extension UserEntity: Identifiable{}
extension UserEntity {
    
    static func create(in managedObjectContext: NSManagedObjectContext,
                       name: String,
                       goal: String) {
        let user = self.init(context: managedObjectContext)
        
        user.name = name
        user.goal = goal
        user.point = 0
        user.total_point = 0
        
        do {
            try  managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
