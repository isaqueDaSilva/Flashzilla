//
//  CardView.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @StateObject var viewModel: CardViewModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(differentiateWithoutColor ? .white : .white.opacity(1 - Double(abs(viewModel.offset.width / 50))))
                .background(
                    differentiateWithoutColor ? nil :
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(viewModel.offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack {
                if voiceOverEnabled {
                    Text(viewModel.isShowingAnswer ? viewModel.card.answer : viewModel.card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(viewModel.card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if viewModel.isShowingAnswer {
                        Text(viewModel.card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(viewModel.offset.width / 5)))
        .offset(x: viewModel.offset.width * 5, y: 0)
        .opacity(2 - Double(abs(viewModel.offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    viewModel.offset = gesture.translation
                    viewModel.feedback.prepare()
                })
                .onEnded({ _ in
                    if abs(viewModel.offset.width) > 100 {
                        viewModel.feedbackPlayAndRemoveItem()
                    } else {
                        viewModel.offset = .zero
                    }
                })
        )
        .onTapGesture {
            viewModel.isShowingAnswer.toggle()
        }
        .animation(.spring, value: viewModel.offset)
    }
    
    init(card: Card, remove: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: CardViewModel(card: card, removal: remove))
    }
}

