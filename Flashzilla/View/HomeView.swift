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
                    ForEach(viewModel.cards) { card in
                        CardView(card: card) {
                            withAnimation {
                                viewModel.removeCard(card: card)
                            }
                        }
                        .stacked(at: viewModel.cardIndex(card: card)!, in: viewModel.cards.count)
                        .allowsHitTesting(viewModel.isValid(card: card))
                        .accessibilityHidden(viewModel.cardIndex(card: card)! < viewModel.cards.count - 1)
                    }
                }
                .allowsHitTesting(viewModel.isPossible())
                
                if viewModel.cards.isEmpty {
                    Button("Start a New Game") {
                        withAnimation {
                            viewModel.gameReset()
                        }
                    }
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                    .padding()
                }
            }
            
            VStack {
                HStack {
                    Button {
                        viewModel.playOrPause()
                    } label: {
                        Image(systemName: viewModel.isActive ? "pause.circle" : "play.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.showingEditCardView = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.title)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                viewModel.removeCard(card: viewModel.cards.last!)
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
                                viewModel.removeCard(card: viewModel.cards.last!)
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
        .sheet(isPresented: $viewModel.showingEditCardView, onDismiss: viewModel.gameReset) {
            EditCardsView()
        }
        
        .onReceive(viewModel.timer, perform: { newTime in
            viewModel.countdown()
        })
        
        .onChange(of: scenePhase, perform: { newPhase in
            if newPhase == .active {
                if !viewModel.cards.isEmpty {
                    if viewModel.status == .play {
                        viewModel.isActive = true
                    }
                }
            } else {
                viewModel.isActive = false
            }
        })
    }
}
