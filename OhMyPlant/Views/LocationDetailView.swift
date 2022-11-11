//
//  LocationDetailView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-12.
//

import SwiftUI
import CoreData

struct LocationDetailView<Item>: View where Item: PlantModelProtocol, Item: CoreDataDeleteableProtocol{
    
    var location: String = ""
    @State var items: [Item]
    
    @State private var selectedItem: Item!
    
    var body: some View {
        List {
            Section(content: {
                ForEach(items) { plant in
                    ItemCell(item:plant) {
                        selectedItem = plant
                    }
                }
                .onDelete { indexs in
                    indexs.forEach { (i) in
                        DispatchQueue.main.async {
                            let item = items.remove(at: i)
                            item.delete()
                        }
                    }
                }
            }, header: {
                Text("\(items.count) plants")
            })
                .headerProminence(.increased)
            
        }
        .navigationTitle(location)
        .popover(item: $selectedItem) { item in
            PlantEditView(plant: .constant(item)) { updated in
                self.selectedItem = updated
            }
        }
    }
}
