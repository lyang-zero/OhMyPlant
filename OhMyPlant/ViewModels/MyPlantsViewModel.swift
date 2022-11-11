//
//  MyPlantsViewModel.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-12.
//

import Foundation
import CoreData

final class MyPlantsViewModel: MyPlantsViewModelProtocol {
    
    typealias Item = PlantViewModel
    
    @Published var items:[Item] = []
    
    
    var plantsByLocation = [String : [Item]]()
    
    var plantCount: Int {
        items.count
    }
 
    var locations: Int {
        plantsByLocation.keys.count
    }
    
    func fetchPlants() {
        let request = Plant.fetchRequest()
        let plants = try? PersistenceController.shared.container.viewContext.fetch(request)
        let models = plants?.map{PlantViewModel($0)} ?? []
        items = models.sorted { !$0.isDead && $1.isDead }
        
        plantsByLocation.removeAll()
        items.forEach { plant in
            let exists = plantsByLocation[plant.location]
            if var exists = exists {
                exists.append(plant)
                exists.sort { !$0.isDead && $1.isDead }
                plantsByLocation[plant.location] = exists
            } else {
                plantsByLocation[plant.location] = [plant]
            }
        }
    }
    
    func deletePlant(at i: IndexSet.Element) {
        items.remove(at: i).delete()
    }
}
