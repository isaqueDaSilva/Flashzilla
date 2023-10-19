//
//  Card+CoreDataProperties.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 18/10/23.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var answer: String?
    @NSManaged public var prompt: String?
    @NSManaged public var id: UUID?
    
    public var wrappedAnswer: String {
        answer ?? "No answer available"
    }
    
    public var wrappedPrompt: String {
        prompt ?? "No prompt available"
    }

}

extension Card : Identifiable {

}
