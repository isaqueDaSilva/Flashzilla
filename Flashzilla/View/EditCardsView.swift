//
//  EditCardsView.swift
//  Flashzilla
//
//  Created by Isaque da Silva on 19/10/23.
//

import SwiftUI

struct EditCardsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = EditCardsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section("Create a New Card") {
                    TextField("Insert your prompt", text: $viewModel.newPrompt)
                    TextField("Insert your answer", text: $viewModel.newAnswer)
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation {
                            viewModel.addNewCard()
                        }
                    } label: {
                        Text("Create New Profile")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(5)
                    }
                    Spacer()
                }
                .listRowBackground(Color(CGColor(red: 240, green: 240, blue: 246, alpha: 0)))
                
                if !viewModel.cards.isEmpty {
                    Section("Cards") {
                        ForEach(viewModel.cards) { card in
                            VStack(alignment: .leading) {
                                Text(card.wrappedPrompt)
                                    .font(.headline)
                                Text(card.wrappedAnswer)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete(perform: viewModel.deleteCard)
                    }
                }
            }
            .navigationTitle("Cards")
            .toolbar {
                ToolbarItem {
                    Button("Done") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    if !viewModel.cards.isEmpty {
                        EditButton()
                    }
                }
            }
        }
    }
}
