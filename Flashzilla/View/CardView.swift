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
                .fill(differentiateWithoutColor ? .white : viewModel.cardFill())
                .background(
                    differentiateWithoutColor ? nil :
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(viewModel.cardFillBackground())
                )
                .shadow(radius: 10)
            
            VStack {
                if voiceOverEnabled {
                    Text(viewModel.accessibilityPromptAndAnswerText())
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(viewModel.prompt())
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if viewModel.isShowingAnswer {
                        Text(viewModel.answer())
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(viewModel.degress()))
        .offset(x: viewModel.offset.width * 5, y: 0)
        .opacity(viewModel.opacity())
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    viewModel.offset = gesture.translation
                    viewModel.feedbackPrepare()
                })
                .onEnded { _ in
                    viewModel.removeOrBackToInitialPosition()
                }
        )
        .onTapGesture {
            withAnimation {
                viewModel.toggle()
            }
        }
        .animation(.spring, value: viewModel.offset)
    }
    
    init(card: Card, remove: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: CardViewModel(card: card, removal: remove))
    }
}

