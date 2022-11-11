//
//  SearchBar.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-19.
//

import SwiftUI

struct SearchBar: View {
    
    @State var searchText = ""
    @State var showCancelButton = false
    var searchCommitHandler: (String?) -> Void
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("search", text: $searchText) { isEditing in
                    withAnimation {
                        self.showCancelButton = true
                    }
                } onCommit: {
                    searchCommitHandler(searchText)
                }
                .foregroundColor(.primary)
                .submitLabel(.search)
                .accentColor(.blue)
                
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText.isEmpty ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .cornerRadius(10.0)
            
            if showCancelButton  {
                Button("Cancel") {
                    UIApplication.shared.endEditing(true)
                    self.searchText = ""
                    self.showCancelButton = false
                    searchCommitHandler(nil)
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

