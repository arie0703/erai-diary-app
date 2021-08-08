import CoreData
import SwiftUI

extension ChallengeEntity {
    
    static func create(in managedObjectContext: NSManagedObjectContext,
                       title: String,
                       comment: String,
                       start_date: Date,
                       end_date: Date,
                       created_at: Date? = Date(),
                       updated_at: Date,
                       continuation_days: Int32,
                       clear_days: Int32,
                       goal: Int32,
                       point: Int32,
                       isDone: Bool){
        let challenge = self.init(context: managedObjectContext)
        challenge.id = UUID().uuidString
        challenge.title = title
        challenge.comment = comment
        challenge.start_date = start_date
        challenge.end_date = end_date
        challenge.created_at = created_at
        challenge.updated_at = updated_at
        challenge.continuation_days = continuation_days
        challenge.clear_days = clear_days
        challenge.goal = goal
        challenge.point = point
        challenge.isDone = false
        do {
            try  managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
