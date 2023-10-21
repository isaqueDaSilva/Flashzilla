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
        
        // Prompt and Answer
        func prompt() -> String {
            card.wrappedPrompt
        }
        
        func answer() -> String {
            card.wrappedAnswer
        }
        
        func accessibilityPromptAndAnswerText() -> String {
            isShowingAnswer ? card.wrappedAnswer : card.wrappedPrompt
        }
        
        //Haptic Feedback
        func feedbackPrepare() {
            feedback.prepare()
        }
        
        func feedbackPlay() {
            if offset.width < 100 {
                feedback.notificationOccurred(.error)
            }
        }
        
        //Toggle
        func toggle() {
            isShowingAnswer.toggle()
        }
        
        //Colors
        func cardFill() -> Color {
            Color.white.opacity(1 - Double(abs(offset.width / 50)))
        }
        
        func cardFillBackground() -> Color {
            offset.width == .zero ? .white : (offset.width > 0 ? .green : .red)
        }
        
        //Card Effect
        func degress() -> Double {
            Double(offset.width / 5)
        }
        
        func opacity() -> Double {
            2 - Double(abs(offset.width / 50))
        }
        
        // Drag Gesture End Action
        func removeOrBackToInitialPosition() {
            if abs(offset.width) > 100 {
                removal()
            } else {
                feedbackPlay()
                offset = .zero
            }
        }
        
        init(card: Card, removal: @escaping () -> Void) {
            _card = Published(initialValue: card)
            self.removal = removal
        }
    }
}
