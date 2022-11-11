//
//  ItemCell.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-12.
//

import SwiftUI

struct ItemCell<Item: PlantModelProtocol>: View {
    
    @EnvironmentObject var appState: AppState
    
    var item: Item
    var tapHandler: (()->Void)?

    var body: some View {
        HStack {
            Button {
                tapHandler?()
            } label: {
                HStack {
                    Image(uiImage: item.image)
                        .resizable()
                        .frame(maxWidth: 60, maxHeight: 60)
                        .cornerRadius(30)
                        .scaledToFit()
                        .padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.name)
                                .font(.title3)
                                .foregroundColor(.label)
                            if item.isDead {
                                Text("(Dead)")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                            }
                            Spacer()
                        }
                        Text(item.location)
                            .font(.footnote)
                            .foregroundColor(.label)
                        Text(item.note ?? "N/A")
                            .font(.footnote)
                            .foregroundColor(.secondaryLabel)
                            .lineLimit(2)
                    }
                    Spacer()
                }
            }
        }
        
    }
}

