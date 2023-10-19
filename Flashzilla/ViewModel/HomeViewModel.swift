//
//  HomeViewModel.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import Foundation

extension HomeView {
    class HomeViewModel: ObservableObject {
        @Published var cards = [Card](repeating: Card.example, count: 10)
        @Published var timeRemaining = 100
        @Published var isActive = true
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        func removeCard(at index: Int) {
            guard index >= 0 else { return }
            
            cards.remove(at: index)
            if cards.isEmpty {
                isActive = false
            }
        }
        
        func countdown() {
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
            cards = [Card](repeating: Card.example, count: 10)
            timeRemaining = 100
            isActive = true
        }
    }
}
