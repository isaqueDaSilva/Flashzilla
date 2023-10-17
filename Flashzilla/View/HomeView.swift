//
//  HomeView.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(viewModel.timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(0..<viewModel.cards.count, id: \.self) { index in
                        CardView(card: viewModel.cards[index]) {
                            withAnimation {
                                viewModel.removeCard(at: index)
                            }
                        }
                            .stacked(at: index, in: viewModel.cards.count)
                    }
                }
                .allowsHitTesting(viewModel.isPossible())
                
                if viewModel.cards.isEmpty {
                    Button("Restart Game") {
                        viewModel.gameReset()
                    }
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                    .padding()
                }
            }
            
            if differentiateWithoutColor {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .foregroundColor (.white)
                    .font (.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(viewModel.timer, perform: { newTime in
            viewModel.countdown()
        })
        
        .onChange(of: scenePhase, perform: { newPhase in
            if newPhase == .active {
                if viewModel.cards.isEmpty {
                    viewModel.isActive = true
                }
            } else {
                viewModel.isActive = false
            }
        })
    }
}
