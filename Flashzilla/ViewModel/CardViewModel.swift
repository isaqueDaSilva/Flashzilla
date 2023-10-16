//
//  CardViewModel.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import Foundation

extension CardView {
    class CardViewModel: ObservableObject {
        @Published var card: Card
        @Published var isShowingAnswer = false
        
        init(card: Card) {
            _card = Published(initialValue: card)
        }
    }
}
