//
//  HomeViewModel.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import Foundation

extension HomeView {
    class HomeViewModel: ObservableObject {
        let manager = CardsManager.shared
        
        @Published var cards = [Card]()
        @Published var timeRemaining = 100
        @Published var isActive = true
        @Published var showingEditCardView = false
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        func getCards() {
            Task { @MainActor in
                await manager.fetchCards()
                cards = await manager.cards
            }
        }
        
        func removeCard(at index: Int) {
            guard index >= 0 else { return }
            
            cards.remove(at: index)
            if cards.isEmpty {
                isActive = false
            }
        }
        
        func countdown() {
            guard !cards.isEmpty else { return }
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        
        func isPossible() -> Bool {
            if timeRemaining > 0 {
                return true
            } else {
                return false
            }
        }
        
        func gameReset() {
            getCards()
            timeRemaining = 100
            isActive = true
        }
        
        init() {
            getCards()
        }
    }
}
