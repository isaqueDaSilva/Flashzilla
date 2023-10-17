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
            cards.remove(at: index)
        }
        
        func countdown() {
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
}
