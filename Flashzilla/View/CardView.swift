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
        .onTapGesture {
            viewModel.isShowingAnswer.toggle()
        }
    }
    
    init(card: Card) {
        _viewModel = StateObject(wrappedValue: CardViewModel(card: card))
    }
}

