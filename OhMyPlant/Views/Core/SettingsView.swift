//
//  SettingsView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("notification") private var notification = true
    @AppStorage("displaymodel") private var selectedDisplayModel = DisplayModel.group
    @AppStorage("albumdisplaymodel") private var albumDisplayModel = AlbumDisplayModel.timeline
    
    var body: some View {
        Form {
            Section {
                Toggle("Notifications", isOn: $notification)
            } header: {
                Text("General")
            }
//            .headerProminence(.increased)
            
//            Section {
//                HStack {
//                    Text("Update Schedule")
//                    Spacer()
//                    Text("after 3 times")
//                        .font(.footnote)
//                        .foregroundColor(.secondaryLabel)
//                    Image(systemName: "chevron.right")
//                }
//            } footer: {
//                Text("Update the care plan of a plant after the times of the difference occure between the scheduled date and the date you actually do")
//            }
//
//            Section {
//                HStack {
//                    Text("Ingore days")
//                    Spacer()
//                    Text("3")
//                        .font(.footnote)
//                        .foregroundColor(.secondaryLabel)
//                    Image(systemName: "chevron.right")
//                }
//            } footer: {
//                Text("Update Schedule will pop up if the difference between the scheduled date and the date you actually watering or fertilizing your plant more than this Ingore days")
//            }
            
            
            Section {
                Picker("Myplants Display Model", selection: $selectedDisplayModel) {
                  ForEach(DisplayModel.allCases) { model in
                      Text(model.rawValue).tag(model)
                  }
                }
                Picker("Album Display Model", selection: $albumDisplayModel) {
                  ForEach(AlbumDisplayModel.allCases) { model in
                      Text(model.rawValue).tag(model)
                  }
                }
//                HStack {
//                    Text("Display Model")
//                    Spacer()
//                    Text("By location")
//                        .font(.footnote)
//                        .foregroundColor(.secondaryLabel)
//                }
            } footer: {
                Text("How plants showing under MyPlants section")
            }
            
            Section {
                Text("This app is always free. If you have any suggestions or concern you think can make this app better, please send them to email lyang.zero@gamil.com ")
            } header: {
                Text("About")
            }
//            .headerProminence(.increased)
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
