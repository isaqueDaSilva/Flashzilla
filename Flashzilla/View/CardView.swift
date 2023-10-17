//
//  CardView.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import SwiftUI

struct CardView: View {
    @StateObject var viewModel: CardViewModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .shadow(radius: 10)
            
            VStack {
                Text(viewModel.card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                if viewModel.isShowingAnswer {
                    Text(viewModel.card.answer)
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(viewModel.offset.width / 5)))
        .offset(x: viewModel.offset.width * 5, y: 0)
        .opacity(2 - Double(abs(viewModel.offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    viewModel.offset = gesture.translation
                })
                .onEnded({ _ in
                    if abs(viewModel.offset.width) > 100 {
                        viewModel.removal()
                    } else {
                        viewModel.offset = .zero
                    }
                })
        )
        .onTapGesture {
            viewModel.isShowingAnswer.toggle()
        }
    }
    
    init(card: Card, remove: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: CardViewModel(card: card, removal: remove))
    }
}

