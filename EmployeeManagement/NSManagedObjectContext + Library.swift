//
//  NSManagedObjectContext + Library.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 04/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ManagedObjectContext: NSManagedObjectContext {
    
    // MARK: Factory Methods
    class func managedObjectContext(isForBackgroundThread: Bool = false, mergeDataChangesFromOtherContexts: Bool = false) -> ManagedObjectContext {
        let concurrencyType: NSManagedObjectContextConcurrencyType = isForBackgroundThread ? .privateQueueConcurrencyType : .mainQueueConcurrencyType
        let managedObjectContext = ManagedObjectContext(concurrencyType: concurrencyType)
        managedObjectContext.persistentStoreCoordinator = ManagedObjectContext.sharedPersistentStoreCoordinator
        
        if mergeDataChangesFromOtherContexts {
            NotificationCenter.default.addObserver(managedObjectContext, selector: #selector(mergeDataChanges(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
        }
        return managedObjectContext
    }

    private static var sharedPersistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let aPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: ManagedObjectContext.sharedManagedObjectModel)
        let dataMigrationOptions = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]   // Enable automatic migration of the database to a new version.
        try! aPersistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: ManagedObjectContext.SQLiteFileURL, options: dataMigrationOptions)
        return aPersistentStoreCoordinator;
    }()
    
    private static var sharedManagedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "EmployeeManagement", withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    private static var SQLiteFileURL: URL = {
        // Store the SQLite file in the Application Support directory as recommended by Apple in the File System Programming Guide.
        let applicationSupportDirectoryPaths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let SQLiteDirectory = applicationSupportDirectoryPaths.first! + "/SQLite"
        if !FileManager.default.fileExists(atPath: SQLiteDirectory) {
            try! FileManager.default.createDirectory(atPath: SQLiteDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        let SQLiteFileName:String = "SQLiteDatabase"
        return URL(fileURLWithPath: SQLiteDirectory, isDirectory: true).appendingPathComponent(SQLiteFileName).appendingPathExtension("sqlite")
    }()
    
    // MARK: Merge Changes from Other Contexts
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(concurrencyType ct: NSManagedObjectContextConcurrencyType) {
        super.init(concurrencyType: ct)
    }
    
    // This method is most often used to merge changes from a background operation (fetch from server) done on a background queue to a managed object context in the main queue. This method is the selector for the NSManagedObjectContextDidSave notification. It is almost always called on a background queue (thread) different from main queue.
    func mergeDataChanges(_ notificationsChangeNotification: Foundation.Notification) {
        let notifier = notificationsChangeNotification.object as! NSManagedObjectContext
        if notifier.persistentStoreCoordinator !== ManagedObjectContext.sharedPersistentStoreCoordinator { return }
        
        if notifier === self { return } // Prevent an infinite loop from changes triggered from this managed object context
        
        // The notification may be fired on different thread/queue. Use perform to use the queue of this managed object context to merge changes. Use perform instead of performAndWait. perform is a asynchronous operation whereas performAndWait is a synchronous one. Using perform may delay the merge operation, but it may also give the main queue the chance to complete a UI operation that it was processing.
        
        // Changed objects in the notification will be safely handled by mergeChanges even if they come from a different thread. But our program itself should not use those managed objects directly.
        perform { self.mergeChanges(fromContextDidSave: notificationsChangeNotification) }
    }
    
}

