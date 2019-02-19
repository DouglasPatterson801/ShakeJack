//
//  Stack.swift
//  Slap Jack
//
//  Created by Douglas Patterson on 1/22/19.
//  Copyright © 2019 Douglas Patterson. All rights reserved.
//

import Foundation
import CoreData

enum Stack {
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Deck")
        container.loadPersistentStores(){ (storeDescription, error) in
            print(storeDescription)
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}
