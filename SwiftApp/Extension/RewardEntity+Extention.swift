import CoreData
import SwiftUI

extension RewardEntity {
    
    static func create(in managedObjectContext: NSManagedObjectContext,
                       content: String,
                       point: Int32,
                       isDone: Bool) {
        let reward = self.init(context: managedObjectContext)
        
        reward.content = content
        reward.point = point
        reward.isDone = false
        
        
        do {
            try  managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
