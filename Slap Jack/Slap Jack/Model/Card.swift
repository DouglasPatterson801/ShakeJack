//
//  Card.swift
//  Slap Jack
//
//  Created by Douglas Patterson on 1/22/19.
//  Copyright © 2019 Douglas Patterson. All rights reserved.
//

import Foundation
import CoreData

extension Card {
    
    convenience init?(dictionary: Dictionary<String, Any>, context: NSManagedObjectContext = Stack.context) {
        guard let suit = dictionary["suit"] as? String,
            let image = dictionary["images"] as? Dictionary<String, Any>,
            let pngURL = image["png"] as? String,
            let value = dictionary["value"] as? String,
            let code = dictionary["code"] as? String
//            let remaining = dictionary["remaining"] as? Int
            else { return nil }
        
        self.init(context: context)
        
        self.suit = suit
        self.image = pngURL
        self.value = value
        self.code = code
        self.remaining = "2"
    }
    
    
}
