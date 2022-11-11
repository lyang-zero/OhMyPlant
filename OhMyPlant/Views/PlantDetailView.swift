//
//  PlantDetail.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-12.
//

import SwiftUI
import CoreData


struct PlantDetailView<Item>: View where Item: PlantModelProtocol {
    
    @Binding var plant: Item
    @State private var showEditView = false
    @State private var showAlbum = false
    
    @StateObject var vm = PlantDetailViewModel()
    
    var body: some View {
        ScrollView {
            ZStack{
                if let plant = plant {
                    Image(uiImage: plant.image)
                        .resizable()
                        .frame(height: 300)
                        .scaledToFill()
                        
                }
                VStack(alignment: .leading){
                    HStack {
                        Spacer()
                        Button {
                            self.showEditView = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 30))
                        }
                    }
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text(plant.name)
                                .font(.system(size: 30, weight: .bold))
                                .lineLimit(1)
                            Text(plant.location)
                                .font(.footnote)
                            Text("You takecare: \(plant.daysYouTakecare) days")
                                .font(.footnote)
                        }
                        Spacer()
                        Button {
                            self.showAlbum = true
                        } label: {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 30))
                        }
                    }
                }
                .foregroundColor(.white)
                .padding()
            }
            
            if vm.actions.count > 0 {
                plantDescription
                    .padding()
            }
            VStack(alignment: .leading) {
                Text("Care Plan")
                    .font(.title3)
                Divider()
                Text(plant.daysToWaterDescription)
                    .font(.subheadline)
                    .lineLimit(1)
                Text(plant.daysToFertilizeDescription)
                    .font(.subheadline)
                    .lineLimit(1)
                Text("Plant to water per \(Int(plant.waterSchedule)) days")
                    .font(.subheadline)
                    .lineLimit(1)
                Text("Plant to water per \(Int(plant.fertilizeSchedule)) days")
                    .font(.subheadline)
                    .lineLimit(1)
                Text("Note")
                    .font(.title3)
                    .padding(.top)
                Divider()
                Text(plant.note ?? "")
                    .foregroundColor(.secondaryLabel)
                    .font(.subheadline)
                Spacer()
            }
            .padding()
        }
        .popover(isPresented: self.$showEditView) {
            PlantEditView(plant: $plant)
        }
        .popover(isPresented: self.$showAlbum) {
            AlbumView(plantId: plant.id)
        }
        .onAppear{vm.fetchActions(plantId: plant.id)}
    }
    
//    @ViewBuilder
//    private var albumView: some View {
//        TabView {
//            Color.cyan
//            Color.yellow
//            Color.blue
//        }
//        .tabViewStyle(.page)
//    }
    
    @ViewBuilder
    private var plantDescription: some View {
        VStack {
            ForEach(vm.actions) { action in
                HStack {
                    VStack(alignment: .trailing, spacing: 4) {
                        Color.cyan
                            .frame(width: 14, height: 14)
                            .cornerRadius(7)
                            .padding(.top, 4)
                        Color.cyan
                            .frame(width: 4)
                            .padding(.trailing, 5)
                    }
                    .frame(maxWidth: 40)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(action.actionDescription)
                            .foregroundColor(.gray)
                            .italic()
                        if let image = action.image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.blue)
                                .padding(.top)
                        }
                        Text(action.note)
                        Spacer()
                    }
                    Spacer()
                }
                .frame(maxHeight: 200)
            }
        }
    }
}

struct PlantDetail_Previews: PreviewProvider {
    static var plant: Plant = {
        let viewContext = PersistenceController.shared.container.viewContext
        let p = Plant(context: viewContext)
        p.location = "Bed room"
        p.name = "Ivy"
        p.note = "I am a note I am a note I am a note I am a note I am a note I am a note I am a note I   I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note"
        return p
    }()
    static var previews: some View {
        PlantDetailView(plant: .constant(PlantViewModel(plant)))
    }
}
