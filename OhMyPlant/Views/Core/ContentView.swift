//
//  ContentView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var tabSelected = 0
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        TabView(selection: $tabSelected) {
            ToDoListView(viewModel: ToDoListViewModel())
                .tabItem {
                    Image(systemName: "drop")
                    Text("Care")
                }
                .tag(1)
            NavigationView {
                MyPlantsView(viewModel: MyPlantsViewModel())
            }.tabItem {
                Image(systemName: "leaf.fill")
                Text("MyPlants")
            }
            .tag(2)
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(3)
        }
        .accentColor(appState.mainThemeColor)
        .onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState.shared)
    }
}
