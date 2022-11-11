//
//  MyPlantsView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import SwiftUI

enum DisplayModel: String, CaseIterable, Identifiable {
    case list = "List", group = "Group"
    
    var id: String {
        self.rawValue
    }
}
protocol MyPlantsViewModelProtocol: ObservableObject {
    
    associatedtype Item: PlantModelProtocol
    // key: locations, values: plants in this location
    var plantsByLocation: [String : [Item]] { get set}
    var items: [Item] { get }
    var plantCount: Int{ get }
    var locations: Int{ get }
    func fetchPlants()
    func deletePlant(at i: IndexSet.Element)
}


struct MyPlantsView<VM: MyPlantsViewModelProtocol>: View {
    
    @StateObject var viewModel: VM
    @EnvironmentObject var appState: AppState
    @State private var selectedItem: VM.Item!
    @State private var showUpAddPlants = false
    @State private var offset: CGPoint = .zero
    
    @AppStorage("displaymodel") private var displayModel = DisplayModel.group
    
    var body: some View {
        List {
            if viewModel.items.count == 0 {
                addPlantView
                    .padding(.vertical)
            } else {
                Section {
                    itemList
                } header: {
                    HStack {
                        Text("Locations: \(viewModel.locations)")
                        Text("Plants: \(viewModel.plantCount)")
                        Spacer()
                    }
                    .foregroundColor(.secondaryLabel)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("My Plants")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    showUpAddPlants = true
                } label:{
                    Image(systemName: "plus")
                }
            }
        })
        .popover(item: $selectedItem, content: { item in
            PlantEditView(plant: Binding($selectedItem)!)
        })
        .popover(isPresented: self.$showUpAddPlants, content: {
            AddPlantView()
        })
        .onAppear {
            viewModel.fetchPlants()
        }
    }
}

extension MyPlantsView {
    
    @ViewBuilder
    fileprivate var itemList: some View {
        if displayModel == .group {
            ForEach(viewModel.plantsByLocation.keys.sorted(by: <), id: \.self) { location in
                plantContainer(title: location, items: viewModel.plantsByLocation[location] ?? [])
            }
            .listRowSeparator(.hidden)
        } else {
            ForEach(viewModel.items) { plant in
                Divider()
                ItemCell(item: plant) {
                    selectedItem = plant
                }
            }
            .onDelete { indexs in
                indexs.forEach { (i) in
                    DispatchQueue.main.async {
                        viewModel.deletePlant(at: i)
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
    }
    
    @ViewBuilder
    private func plantContainer(title: String, items: [VM.Item]) -> some View {
        let count = items.count
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .foregroundColor(.label)
                Text("\(count) plants")
                    .font(.footnote)
                    .foregroundColor(.secondaryLabel)
                HStack(spacing: 1) {
                    if count > 0 {
                        Image(uiImage: items[0].image)
                            .resizable()
                            .frame(width: 81, height: 121)
                            .scaledToFit()
                    } else {
                        Color.secondarySystemBackground
                            .frame(width: 81, height: 121)
                    }
                    VStack(spacing: 1) {
                        HStack(spacing: 1) {
                            if count > 1 {
                                Image(uiImage: items[1].image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .scaledToFit()
                            } else {
                                Color.secondarySystemBackground
                                    .frame(width: 50, height: 50)
                            }
                            
                            if count > 2 {
                                Image(uiImage: items[2].image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .scaledToFit()
                            } else {
                                Color.secondarySystemBackground
                                    .frame(width: 50, height: 50)
                            }
                            
                        }
                        if count > 3 {
                            Image(uiImage: items[3].image)
                                .resizable()
                                .frame(width: 101, height: 70)
                                .scaledToFit()
                        } else {
                            Color.secondarySystemBackground
                                .frame(width: 101, height: 70)
                        }
                    }
                    if count > 4 {
                        Image(uiImage: items[4].image)
                            .resizable()
                            .frame(maxHeight: 121)
                            .clipped()
                    } else {
                        Color.secondarySystemBackground
                    }
                }
            }
            NavigationLink(destination: LocationDetailView(location: title, items: items as! [PlantViewModel])) {
                EmptyView()
            }
            .frame(width: 0)
            .opacity(0)
        }
    }
    
    @ViewBuilder
    private var addPlantView: some View {
        HStack {
            Image(systemName: "plus.circle")
                .font(.system(size: 40))
                .foregroundColor(appState.mainThemeColor)
            VStack(alignment: .leading) {
                Text("Add Plants")
                    .foregroundColor(.label)
                Text("and take care of them here")
                    .font(.footnote)
                    .foregroundColor(.secondaryLabel)
            }
            Spacer()
        }
        .onTapGesture {
            self.showUpAddPlants = true
        }
    }
}

struct MyPlantsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPlantsView(viewModel: MyPlantsViewModel())
            .environmentObject(AppState.shared)
    }
}
