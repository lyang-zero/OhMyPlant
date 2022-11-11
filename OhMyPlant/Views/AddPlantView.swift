//
//  AddPlantView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-12.
//

import SwiftUI

struct AddPlantView: View {
    
    @State private var currentStep = 1
    @State private var pickImageFromPhoto = false
    @State private var takeImageUsingCamera = false
    
    @State private var image: UIImage?
    @State private var plantName: String = ""
    @State private var location: String = ""
    @State private var note: String = ""
    @State private var daysToWater: String = ""
    @State private var daysToFeritilize: String = ""
    
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if currentStep == 1 {
                choosePhoto
            } else {
                HStack {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(appState.mainThemeColor)
                    }
                    Spacer()
                    Button {
                        PlantViewModel(image: image?.pngData() ,name: plantName, location: location, daysToWater: Int(daysToWater)!, daysToFertilize: Int(daysToFeritilize)!, note: note)
                        mode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                            .foregroundColor(appState.mainThemeColor)
                    }
                }
                plantProfile
                    .transition(.slide)
            }
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color.secondarySystemBackground)
        
    }
}

extension AddPlantView {
    
    @ViewBuilder
    fileprivate var choosePhoto: some View {
        VStack {
            Button {
                takeImageUsingCamera = true
            }label: {
                Image(systemName: "camera")
                    .font(.largeTitle)
                Text("Chosse from Photos")
            }
            .padding()
            .background(Color.systemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .popover(isPresented: $takeImageUsingCamera) {
                ImagePicker(image: $image, sourceType: .camera){
                    withAnimation {
                        currentStep = 2
                    }
                }
            }
            Button {
                pickImageFromPhoto = true
            }label: {
                Image(systemName: "photo")
                    .font(.largeTitle)
                Text("Chosse from Photos")
            }
            .padding()
            .background(Color.systemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .popover(isPresented: $pickImageFromPhoto) {
                ImagePicker(image: $image){
                    withAnimation {
                        currentStep = 2
                    }
                }
            }
            
            Button("Skip") {
                withAnimation {
                    image = UIImage(named:"default_plant")
                    currentStep = 2
                }
            }
            .padding()
            .background(Color.systemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxWidth: .infinity)
        
    }
    
    @ViewBuilder
    fileprivate var plantProfile: some View {
        Form {
            Section {
                HStack {
                    Image(uiImage: image!)
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .cornerRadius(10)
                    Spacer()
                }
                .listRowInsets(EdgeInsets())
            } header: {
                Text("Image")
            }
            .background(Color.secondarySystemBackground)
            
            Section {
                TextField("",text: $plantName, prompt: Text("plant name"))
                TextField("", text: $location, prompt: Text("location"))
            } header: {
                Text("profile")
            }
            
            Section {
                TextField("", text: $daysToWater, prompt: Text("days to water"))
                    .keyboardType(.numberPad)
                TextField("", text: $daysToFeritilize, prompt: Text("days to fertilize"))
                    .keyboardType(.numberPad)
            } header: {
                Text("Care plan")
            } footer: {
                Text("Watering and fertilize your plant per days")
            }
            
            Section {
                TextEditor(text: $note)
                    .frame(minHeight: 100)
            } header: {
                Text("note")
            }
        }
    }
}

struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView()
    }
}
