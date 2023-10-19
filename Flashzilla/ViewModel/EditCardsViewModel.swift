//
//  EditCardsViewModel.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 19/10/23.
//

import Foundation

extension EditCardsView {
    class EditCardsViewModel: ObservableObject {
        let manager = CardsManager.shared
        
        @Published var cards = [Card]()
        @Published var newPrompt = ""
        @Published var newAnswer = ""
        
        var isValid: Bool {
            if newPrompt.isEmpty || newAnswer.isEmpty {
                return false
            } else {
                return true
            }
        }
        
        func getCards() {
            Task { @MainActor in
                await manager.fetchCards()
                cards = await manager.cards
            }
        }
        
        func addNewCard() {
            Task { @MainActor in
                await manager.createNewCard(prompt: newPrompt,answer: newAnswer)
                getCards()
                newPrompt = ""
                newAnswer = ""
            }
        }
        
        func deleteCard(at indexSet: IndexSet) {
            Task { @MainActor in
                guard let index = indexSet.first else { return }
                let card = cards[index]
                await manager.deleteCard(card: card)
                getCards()
            }
        }
        
        init() {
            getCards()
        }
    }
}
