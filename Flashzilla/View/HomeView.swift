//
//  HomeView.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            VStack {
                ZStack {
                    ForEach(0..<viewModel.cards.count, id: \.self) { index in
                        CardView(card: viewModel.cards[index])
                            .stacked(at: index, in: viewModel.cards.count)
                    }
                }
            }
        }
    }
}
