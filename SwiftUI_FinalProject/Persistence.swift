//
//  Persistence.swift
//  SwiftUI_FinalProject
//
//  Created by 邵安祺 on 2022/1/18.
//
import UIKit
import SwiftUI
import CoreData

struct PersistenceController {
    //A singleton for entire app to use
    static let shared = PersistenceController()
    
    //A fake testing data
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for idx in 0..<5 {
            let newItem = MyFav(context: viewContext)
            newItem.timestamp = Date()
            newItem.gymName = "排球場\(String(idx))"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    //Storage for Core Data
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyFavData")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores{ dscrp, err in
            if let error = err {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //check whether the context has changed
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func getManagedObjectContext() -> NSManagedObjectContext{
        return container.viewContext
    }
}


