//
//  CardController.swift
//  Slap Jack
//
//  Created by Douglas Patterson on 1/17/19.
//  Copyright © 2019 Douglas Patterson. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CardController {
    
    //==================================================
    // MARK: - Properties
    //==================================================
    static let sharedController = CardController()
    let shuffleNewDeckUrl = URL(string: "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1")
    
    var deckArray: [Deck] {
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        
        do {
            return try Stack.context.fetch(request)
        } catch {
            return []
        }
    }
    
    //==================================================
    // MARK: - API Work
    //==================================================
    
    //Obtain Deck to Utilize DeckId
    func getDeck(completion: @escaping ((Deck?) -> Void)) {
        
        NetworkController.performNetworkRequest(for: shuffleNewDeckUrl!) { (data, error) in
            guard let data = data else { return }
            
            
            let jsonObjects = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let dictionary = jsonObjects as? Dictionary<String, Any> {
                
                print(dictionary.description)
                
                guard let results = Deck(dictionary: dictionary) else  {
                    print("Error")
                    return
                }
                completion(results)
                self.saveToPersistentStorage()
            }
        }
    }
    
    // Draw a Card **DeckId Required**
    func drawCard(deckId: String, completion: @escaping ((Card?) -> Void)) {
        
        guard let url = URL(string: "https://deckofcardsapi.com/api/deck/\(deckId)/draw/?count=1") else { return }

        NetworkController.performNetworkRequest(for: url) { (data, error) in
            guard let data = data else { return }
            
            do {
            let jsonObjects = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = jsonObjects as? Dictionary<String, Any>,
                    let cards = dictionary["cards"] as? [Dictionary<String, Any>] {
                    let cardDictionary = cards[0]
                    let results = Card(dictionary: cardDictionary)
                    completion(results)
                }
            }
        }

    }
    
    // Get the card image that will be displayed in the the UIImabeview
    
    func getImage(card: Card, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = card.image,
            let cardUrl = URL(string: url) else { return }
        NetworkController.performNetworkRequest(for: cardUrl) { (data, error) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
 
    
    //==================================================
    // MARK: - CoreData Work
    //==================================================
    func deleteDeck(deck: Deck) {
        Stack.context.delete(deck)
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        
        do {
            try Stack.context.save()
        } catch {
            print("Error. Could not save to persistent storage.")
        }
    }
    
    
    
}


