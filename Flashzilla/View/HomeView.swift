//
//  HomeView.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        ZStack {
            Image(decorative: "background")
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
                        .allowsHitTesting(index == viewModel.cards.count - 1)
                        .accessibilityHidden(index < viewModel.cards.count - 1)
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
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.removeCard(at: viewModel.cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                viewModel.removeCard(at: viewModel.cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor (.white)
                    .font(.largeTitle)
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
