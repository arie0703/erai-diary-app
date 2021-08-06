import CoreData
import SwiftUI

extension TemplateEntity {
    
    static func create(in managedObjectContext: NSManagedObjectContext,
                       content: String,
                       rate: Int32,
                       created_at: Date? = Date()){
        let template = self.init(context: managedObjectContext)
        
        template.content = content
        template.rate = rate
        template.created_at = created_at
        
        do {
            try  managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}

