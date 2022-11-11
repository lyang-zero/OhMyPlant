//
//  CareView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-19.
//

import SwiftUI

struct CareView<VM: ToDoListViewModelProtocol>: View {
    
    @ObservedObject var viewModel: VM
    @Environment(\.presentationMode) var mode
    var item: VM.Item
    
    @State private var note: String = "Regular."
    
    var body: some View {
        VStack(spacing: 0) {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .clipped()
                
            Form {
                Section{
                    TextEditor(text: $note)
                        .frame(height: 100)
                } header: {
                    Text("Note")
                }
                Section {
                    Button("Water") {
                        viewModel.watering(item, note: note)
                        mode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth:.infinity)
                    Button("Fertilize"){
                        viewModel.fertilizing(item, note: note)
                        mode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth:.infinity)
                }
            }
        }
    }
}

struct CareView_Previews: PreviewProvider {
    static var plant: Plant = {
        let viewContext = PersistenceController.shared.container.viewContext
        let p = Plant(context: viewContext)
        p.location = "Bed room"
        p.name = "Ivy"
        p.note = "I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note"
        return p
    }()
    static var previews: some View {
        CareView(viewModel: ToDoListViewModel(), item: PlantViewModel(plant))
    }
}
