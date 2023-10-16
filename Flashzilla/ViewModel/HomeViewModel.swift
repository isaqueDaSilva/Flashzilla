//
//  HomeViewModel.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 16/10/23.
//

import Foundation

extension HomeView {
    class HomeViewModel: ObservableObject {
        @Published var cards = [Card](repeating: Card.example, count: 10)
    }
}
