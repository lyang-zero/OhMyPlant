//
//  AlbumViewModel.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-20.
//

import Foundation
import UIKit

final class AlbumViewModel: ObservableObject {
    
    @Published var images: [Album] = []
    
    func fetchImages(plantId: String) {
        let request = Album.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.predicate = NSPredicate(format: "plantId=%@", plantId)
        
        images.removeAll()
        images += (try? PersistenceController.shared.container.viewContext.fetch(request)) ?? []
    }
    
    func addImage(uiimage: UIImage?, plantId: String) {
        if let uiimage = uiimage {
            let album = Album(context: PersistenceController.shared.container.viewContext)
            album.timestamp = Date()
            album.image = uiimage.jpegData(compressionQuality: 0.6)
            album.plantId = plantId
            
            try? album.managedObjectContext?.save()
            
            addAction(plantId: plantId, image: uiimage)
            
            fetchImages(plantId: plantId)
        }
    }
    
    private func addAction(plantId: String, image: UIImage) {
        let action = CareAction(context: PersistenceController.shared.container.viewContext)
        action.plantId = plantId
        action.timestamp = Date()
        action.image = image.jpegData(compressionQuality: 0.6)
        action.actionDescription = "Taked picture on \(action.dateString())"
        try? action.managedObjectContext?.save()
    }
}

extension Album {
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: timestamp ?? Date())
    }
}
