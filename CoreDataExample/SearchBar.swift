//
//  SearchBarView.swift
//  Cinema
//
//  Created by Finnis on 20/03/2021.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    @State private var isEditing = false
 
    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(8)
                .padding(.horizontal, 30)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(11)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 9)
                 
                        if isEditing {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 9)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
                .onTapGesture {
                    isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .padding(.trailing, 10)
                }
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
