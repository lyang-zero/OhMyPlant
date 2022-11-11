//
//  AlbumView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-20.
//

import SwiftUI

enum AlbumDisplayModel: String, CaseIterable, Identifiable {
    case timeline = "Time Line", gallery = "Gallery"
    var id: String {
        self.rawValue
    }
}

struct AlbumView: View {
    let plantId: String
    
    @StateObject var vm = AlbumViewModel()
    @Environment(\.presentationMode) var mode
    @AppStorage("albumdisplaymodel") private var albumDisplayModel = AlbumDisplayModel.timeline
    
    @State private var pickImageFromPhoto = false
    @State private var takeImageUsingCamera = false
    @State private var showImagePicker = false
    @State private var pickedImage: UIImage?
    
    var body: some View {
        ScrollView {
            if albumDisplayModel == .timeline {
                timeLineView
            } else {
                galleryView()
            }
        }
        .onAppear {
            vm.fetchImages(plantId: plantId)
        }
        .popover(isPresented: $showImagePicker) {
            choosePhoto
        }
    }
}


extension AlbumView {
    @ViewBuilder
    var timeLineView: some View {
        if vm.images.count > 0 {
            HStack {
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    showImagePicker = true
                }label: {
                    Text("Add")
                }
            }
            .padding([.top, .leading, .trailing])
        } else {
            VStack(alignment: .center){
                Button("Add a picture") {
                    showImagePicker = true
                }
                .frame(width: 140, height: 80)
                .background(.cyan)
                .cornerRadius(10)
                .foregroundColor(.white)
            }.frame(height: UIScreen.main.bounds.height - 100)
        }
        ForEach(vm.images) { image in
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
                    Text("Taked on \(image.dateString())")
                        .foregroundColor(.gray)
                        .italic()
                    if let image = image.image {
                        Image(uiImage: UIImage(data: image)!)
                            .resizable()
                            .frame(height: 200)
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(10)
                            .padding(.top)
                    }
                    Spacer()
                }
                Spacer()
            }
            .frame(maxHeight: 240)
        }
    }
    
    @ViewBuilder
    private func galleryView() -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        LazyVGrid(columns: columns) {
            ForEach(vm.images) { image in
                if let image = image.image {
                    Image(uiImage: UIImage(data: image)!)
                        .resizable()
                        .aspectRatio(3/4, contentMode: .fit)
                }
            }
            Button {
                showImagePicker = true
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.label)
                    .font(.system(size: 40))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(10)
        }
    }
    
    
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
                ImagePicker(image: $pickedImage, sourceType: .camera, allowsEditing: false){
                    self.showImagePicker = false
                    self.vm.addImage(uiimage: pickedImage, plantId: plantId)
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
                ImagePicker(image: $pickedImage, allowsEditing: false){
                    self.showImagePicker = false
                    self.vm.addImage(uiimage: pickedImage, plantId: plantId)
                }
            }
        }
        .frame(maxWidth: .infinity)
        
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView(plantId: "")
    }
}
