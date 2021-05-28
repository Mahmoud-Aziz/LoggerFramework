//
//  CoreData.swift
//  InstabugInternshipTask
//
//  Created by Mahmoud Aziz on 26/05/2021.
//

import Foundation
import CoreData

 class CoreDataManager: Database {
    
    static let shared = CoreDataManager()
    private var savedLogs: [LogModel]?

    //MARK:- Database Protocol Stubs
    
    func save(log: LogModel) {
        backgroundContext.performAndWait {
            let log = LogModel(context: backgroundContext)
            log.message = log.message
            log.date = log.date
            log.level = log.level
            backgroundContext.insert(log)
            savedLogs?.append(log)
        }
    }
    
    func fetch() -> [LogModel] {
        backgroundContext.performAndWait {
            let fetchRequest: NSFetchRequest<LogModel> = LogModel.fetchRequest()
            do {
                savedLogs = try backgroundContext.fetch(fetchRequest)
            } catch {
                print(error)
            }
        }
        
      return savedLogs ?? []
    }
    
    func remove(log: LogModel) {
        let objectID = log.objectID
        backgroundContext.performAndWait {
          if let existingObject = try? backgroundContext.existingObject(with: objectID) {
            backgroundContext.delete(existingObject)
            try? backgroundContext.save()
          }
        }
    }
    
    func removeAll() {
        backgroundContext.performAndWait {
            let allLogs = fetch()
            for log in allLogs {
                backgroundContext.delete(log)
            }
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let newBackgroundContext = persistentContainer.newBackgroundContext()
        newBackgroundContext.automaticallyMergesChangesFromParent = true
        return newBackgroundContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Log")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
