//
//  PlantEditView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-18.
//

import SwiftUI
import CoreData

struct PlantEditView<Item>: View where Item: PlantModelProtocol {
    
    @Binding var item: Item
    var dismissHandler: ((Item?)->Void)?
    @Environment(\.presentationMode) var mode
    
    @State private var note: String
    @State private var name: String
    @State private var location: String
    @State private var daysToWater: String
    @State private var daysToFertilize: String
    
    init(plant: Binding<Item>, dismissHandler: ((Item)->Void)? = nil) {
        self._item = plant
        self._note = State(initialValue: plant.wrappedValue.note ?? "")
        self._name = State(initialValue: plant.wrappedValue.name)
        self._location = State(initialValue: plant.wrappedValue.location)
        self._daysToWater = State(initialValue: plant.wrappedValue.waterSchedule != 0 ? "\(Int(plant.wrappedValue.waterSchedule))" : "N/A")
        self._daysToFertilize = State(initialValue: plant.wrappedValue.fertilizeSchedule != 0 ? "\(Int(plant.wrappedValue.fertilizeSchedule))" : "N/A")
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.cyan)
                }
                
                Spacer()
                
                Button {
                    save()
                    mode.wrappedValue.dismiss()
                }label: {
                    Text("Done")
                        .foregroundColor(.cyan)
                }
            }
            .padding([.top, .leading, .trailing])
            Form {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("", text: $name, prompt: Text("name"))
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Location")
                        Spacer()
                        TextField("", text: $location, prompt: Text("location"))
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    VStack(alignment: .leading){
                        Text("Note:")
                        TextEditor(text: $note)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                } header: {
                    Text("Detail")
                }
                
                Section {
                    HStack{
                        Text("Days to Water")
                        Spacer()
                        TextField("", text: $daysToWater, prompt: Text("Days to Water"))
                            .keyboardType(.numberPad)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Days to fertilize")
                        Spacer()
                        TextField("", text: $daysToFertilize, prompt: Text("Days to fertilize"))
                            .keyboardType(.numberPad)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                } header: {
                    Text("Care Plan")
                }
                Section {
                    Button(item.isDead ? "Dead" : "Mark as dead") {
                        item.isDead = true
                        save()
                        mode.wrappedValue.dismiss()
                    }
                    .disabled(item.isDead)
                    .foregroundColor( item.isDead ? .gray : .red)
                    .frame(maxWidth:.infinity)
                }
            }
        }
        .onDisappear {
            dismissHandler?(item)
        }
    }
    
    
    private func save() {
        item.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        item.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        item.note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        item.waterSchedule = Double(Int(daysToWater) ?? 0)
        item.fertilizeSchedule = Double(Int(daysToFertilize) ?? 0)
        try? PersistenceController.shared.container.viewContext.save()
    }
}

struct PlantEditView_Previews: PreviewProvider {
    static var plant: Plant = {
        let viewContext = PersistenceController.shared.container.viewContext
        let p = Plant(context: viewContext)
        p.location = "Bed room"
        p.name = "Ivy"
        p.note = "I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a  note"
        return p
    }()
    static var previews: some View {
        PlantEditView(plant: .constant(PlantViewModel(plant)))
    }
}
