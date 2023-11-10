//
//  HomeViewModel.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import Foundation
import SwiftUI

extension HomeView {
    class HomeViewModel: ObservableObject {
        let manager = CardsManager()
        
        @Published var cards = [Card]()
        @Published var timeRemaining = 100
        @Published var isActive = true
        @Published var showingEditCardView = false
        @AppStorage("Status") var status: GameStatus = .play
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        func playOrPause() {
            withAnimation {
                isActive.toggle()
            }
            if isActive {
                status = .play
            } else {
                status = .pause
            }
        }
        
        func scenePhase() {
            if !cards.isEmpty {
                if status == .play {
                    isActive = true
                }
            }
        }
        
        func cardIndex(card: Card) -> Int? {
            guard let index = cards.firstIndex(of: card) else { return nil }
            
            return index
        }
        
        func isValid(card: Card) -> Bool {
            guard isActive else { return false }
            let index = cardIndex(card: card)
            
            return index! == cards.count - 1 ? true : false
        }
        
        func isPossible() -> Bool {
            timeRemaining > 0 ? true : false
        }
        
        func getCards() {
            Task { @MainActor in
                await manager.fetchCards()
                cards = await manager.cards
            }
        }
        
        func removeCard(card: Card) {
            let index = cardIndex(card: card)
            
            cards.remove(at: index!)
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
