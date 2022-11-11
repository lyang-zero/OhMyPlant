//
//  ToDoListView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import SwiftUI


enum PlantSorting: String {
    case daysToWater = "Water"
    case daysToFertilize = "Fertilize"
    case name = "Name"
}

protocol ToDoListViewModelProtocol: ObservableObject {
    associatedtype Item: BasicPlantModelProtocol
    var items: [Item] { get set}
    var sortBy: PlantSorting {get set}
    func search(by text: String?)
    func watering(_ item: Item, note: String)
    func fertilizing(_ item: Item, note: String)
    func careDescriptionColor(_ item: Item) -> Color
    func fetch()
}

struct ToDoListView<VM: ToDoListViewModelProtocol>: View {
    
    @StateObject var viewModel: VM
    @EnvironmentObject var appState: AppState
    
    var weatherViewHeight: CGFloat = 160
    private var contentOffset: CGFloat {
        weatherViewHeight +  (-offset.y < -40 ? -40 : -offset.y)
    }
    
    @State private var offset: CGPoint = .zero
    
    @State private var showUpAddPlants = false
    @State private var selectedItem: VM.Item?
    @State private var selectedItemForPopover: VM.Item?
    @State private var showForPopover = false
    
    @StateObject private var weatherVM = WeatherViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                WeatherView(viewModel: weatherVM)
                    .frame(height: contentOffset)
                Spacer()
            }
            ObservableScrollView(offset: $offset,
                                 showIndicator: false, axis: .vertical) {
                Color.clear
                    .frame(height: -offset.y < 40 ? 40 : -offset.y)
                
                if viewModel.items.count > 0 {
                    SearchBar { searchText in
                        viewModel.search(by: searchText)
                    }
                    .padding()
                }
                VStack {
                    itemListView(items: viewModel.items)
                    if viewModel.items.count < 3 {
                        addItemView()
                    }
                }
                .background(Color.systemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                Spacer(minLength: 20)
            }
                                 .padding(.top, 120)
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.secondarySystemBackground)
        .sheet(item: self.$selectedItemForPopover, onDismiss: {
            viewModel.fetch()
        }, content: { item in
            PlantDetailView(plant: .constant(item as! PlantViewModel))
        })
        .sheet(item: self.$selectedItem, onDismiss: {
            viewModel.fetch()
        }, content: { item in
            CareView(viewModel: viewModel, item: item)
        })
        .onAppear(perform: viewModel.fetch)
    }
    
    @State private var showingWateringAlert = false
    @State private var showingFertilizingAlert = false
    
    @ViewBuilder
    private func itemListView(items: [VM.Item]) -> some View {
        if items.count > 0 {
            HStack {
                Text("Sort By: \(viewModel.sortBy.rawValue)")
                    .padding()
                Spacer()
                sortMenu()
            }
            Divider()
        }
        if items.count == 0 {
            ForEach(1..<3) { _ in
                HStack {
                    Color.gray
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                        .opacity(0.6)
                    
                    VStack(alignment: .leading) {
                        Color.gray
                            .frame(maxWidth: 160, maxHeight: 10)
                        Color.gray
                            .frame(maxWidth: 80, maxHeight: 10)
                        Color.gray
                            .frame(width: 60, height: 10)
                    }
                    .opacity(0.6)
                    Spacer()
                }
                .padding()
            }
            Divider()
        }
        ForEach(items) { item in
            itemCell(item)
                .padding(.horizontal)
        }
        if items.count >= 3 {
            Spacer(minLength: 20)
        }
    }
}

extension ToDoListView {
    
    @ViewBuilder
    private func itemCell(_ item: VM.Item) -> some View {
        HStack {
            Button {
                self.selectedItemForPopover = item
                self.showForPopover = true
            } label: {
                HStack {
                    Image(uiImage: item.image)
                        .resizable()
                        .frame(maxWidth: 60, maxHeight: 60)
                        .cornerRadius(30)
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.title3)
                            .foregroundColor(.label)
                            .lineLimit(1)
                        Text(item.location)
                            .font(.footnote)
                            .foregroundColor(.label)
                            .lineLimit(1)
                        Text(viewModel.sortBy == .daysToFertilize ? item.daysToFertilizeDescription : item.daysToWaterDescription)
                            .font(.footnote)
                            .foregroundColor(viewModel.careDescriptionColor(item))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    Spacer()
                }
            }
            CareMenu(item)
        }
    }
    
    //    @ViewBuilder
    //    private func actionMenus(_ item: VM.Item) -> some View {
    //        Button (action:{
    //            self.selectedItem = item
    //        },label:{
    //            Text("Watering")
    //            Image(systemName: "drop")
    //                .font(.system(size: 30))
    //                .foregroundColor(appState.mainThemeColor)
    //        })
    //
    //        Button (action:{
    //            self.selectedItem = item
    //        },label:{
    //            Text("Fertilizing")
    //            Image("fertilizer")
    //                .renderingMode(.template)
    //                .resizable()
    //                .frame(maxWidth: 30, maxHeight:30)
    //                .foregroundColor(appState.mainThemeColor)
    //        })
    //    }
    
    @ViewBuilder
    private func CareMenu(_ item: VM.Item) -> some View {
        Button {
            //            actionMenus(item)
            self.selectedItem = item
        } label: {
            Image(systemName: "heart")
                .font(.system(size: 30))
                .foregroundColor(appState.mainThemeColor)
        }
    }
    
    @ViewBuilder
    private func sortMenu() -> some View {
        Menu {
            Button {
                withAnimation {
                    viewModel.sortBy = .name
                }
            } label: {
                Label("Name", systemImage: "arrow.down.circle")
            }
            Button {
                withAnimation {
                    viewModel.sortBy = .daysToWater
                }
            } label: {
                Label("Water", systemImage: "arrow.down.circle")
            }
            Button {
                withAnimation {
                    viewModel.sortBy = .daysToFertilize
                }
            } label: {
                Label("Fertilize", systemImage: "arrow.down.circle")
            }
        } label: {
            Text("Sort")
                .foregroundColor(appState.mainThemeColor)
            Image(systemName: "slider.vertical.3")
                .font(.system(size: 30))
                .foregroundColor(appState.mainThemeColor)
        }
        .padding()
    }
    
    @ViewBuilder
    private func addItemView() -> some View {
        if viewModel.items.count > 0 {
            Divider()
        }
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
        .padding()
        .onTapGesture {
            self.showUpAddPlants = true
        }
        .popover(isPresented: $showUpAddPlants) {
            AddPlantView()
        }
    }
}



struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(viewModel: ToDoListViewModel())
            .environmentObject(AppState.shared)
    }
}
