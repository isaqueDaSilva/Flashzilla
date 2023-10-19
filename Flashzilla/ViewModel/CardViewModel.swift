//
//  CardViewModel.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import Foundation
import SwiftUI

extension CardView {
    class CardViewModel: ObservableObject {
        @Published var card: Card
        @Published var isShowingAnswer = false
        @Published var offset = CGSize.zero
        @Published var feedback = UINotificationFeedbackGenerator()
        
        var removal: () -> Void
        
        func feedbackPlayAndRemoveItem() {
            if offset.width < 100 {
                feedback.notificationOccurred(.error)
            }
            removal()
        }
        
        init(card: Card, removal: @escaping () -> Void) {
            _card = Published(initialValue: card)
            self.removal = removal
        }
    }
}
