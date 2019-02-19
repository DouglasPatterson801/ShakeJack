//
//  NewDeck.swift
//  Slap Jack
//
//  Created by Douglas Patterson on 1/18/19.
//  Copyright © 2019 Douglas Patterson. All rights reserved.
//

import Foundation
import CoreData

extension Deck {
    
    
    convenience init?(dictionary: Dictionary<String, Any>, context: NSManagedObjectContext = Stack.context) {
        guard let success = dictionary["success"] as? Bool,
        let deckId = dictionary["deck_id"] as? String,
        let shuffled = dictionary["shuffled"] as? Bool,
        let remaining = dictionary["remaining"] as? Int16 else { return nil}
        
        self.init(context: context)
        
        self.success = success
        self.deck_id = deckId
        self.shuffled = shuffled
        self.remaining = remaining
    }
    
   
    
}

