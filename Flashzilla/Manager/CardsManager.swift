//
//  CardsManager.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 18/10/23.
//

import CoreData
import Foundation

actor CardsManager {
    var cards: [Card]
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private func save() {
        do {
            try context.save()
            fetchCards()
        } catch let error {
            print("Falied to loading Cards. Error: \(error)")
        }
    }
    
    func fetchCards() {
        let request = NSFetchRequest<Card>(entityName: "Card")
        
        do {
            cards = try context.fetch(request)
        } catch let error {
            print("Falied to fetch Cards. Error: \(error)")
        }
    }
    
    func createNewCard(prompt: String, answer: String) {
        let newCard = Card(context: context)
        newCard.id = UUID()
        newCard.prompt = prompt
        newCard.answer = answer
        save()
    }
    
    func deleteCard(card: Card) {
        context.delete(card)
        save()
    }
    
    init() {
        self.cards = []
        self.container = NSPersistentContainer(name: "CardModel")
        self.context = container.viewContext
        
        self.container.loadPersistentStores { (success, error) in
            if (error != nil) {
                print("Falied to loading Cards.")
            }
        }
        self.context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
