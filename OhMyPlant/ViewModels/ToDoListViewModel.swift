//
//  ToDoListViewModel.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import Foundation
import SwiftUI

final class ToDoListViewModel: ToDoListViewModelProtocol {
    
    typealias Item = PlantViewModel
    @Published var items = [Item]()
    
    init(){
//        reCreateData()
        fetch()
    }
    
    func fetch(){
        let request = Plant.fetchRequest()
        request.predicate = NSPredicate(format: "isDead = %@", false)
        let plants = try? PersistenceController.shared.container.viewContext.fetch(request)
        items = plants?.map{PlantViewModel($0)} ?? []
        sort()
    }
    
    func watering(_ item: Item, note: String) {
        item.watering()
        
        //record action
        addAction(plantId: item.id, actionType: .water, note: note)
        
        NotificationManager.update(plantId: item.id, timeInterval: Int(item.waterSchedule), title: item.name, notificationType: .water)

        
        sort()
    }
    
    func fertilizing(_ item: Item, note: String) {
        item.fertilizing()
        //record action
        addAction(plantId: item.id, actionType: .fertilize, note: note)
        
        NotificationManager.update(plantId: item.id, timeInterval: Int(item.fertilizeSchedule), title: item.name, notificationType: .fertilize)
        
        sort()
    }
    
    func search(by name: String?) {
        if let name = name?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            items = items.filter{$0.name.lowercased().contains(name)}
        } else {
            fetch()
        }
    }
    
    func careDescriptionColor(_ item: PlantViewModel) -> Color {
        if sortBy == .daysToFertilize {
            return  item.daysToFertilize == nil || item.daysToFertilize! > 1 ? .gray : .orange
        } else {
            return  item.daysToWater == nil || item.daysToWater! > 1 ? .gray : .orange
        }
    }
    
    //MARK: - sorting
    var sortBy: PlantSorting = .daysToWater {
        didSet{
            sort()
        }
    }
    var sortDescription: String {
        sortBy.rawValue
    }
    
    private func sort(){
        switch sortBy {
        case .daysToWater:
            sortByDaysToWater()
        case .daysToFertilize:
            sortByDaysToFertilize()
        case .name:
            sortByName()
        }
    }
    
    func sortByDaysToWater() {
        var result = items.filter{
            $0.daysToWater != nil
        }.sorted{$0.daysToWater! < $1.daysToWater!}
        result += items.filter {$0.daysToWater == nil}
        items = result
    }
    
    func sortByDaysToFertilize() {
        var result = items.filter{
            $0.daysToFertilize != nil
        }.sorted{$0.daysToFertilize! < $1.daysToFertilize!}
        result += items.filter {$0.daysToFertilize == nil}
        items = result
    }
    
    func sortByName() {
        items = items.sorted(by: \.name)
    }
    
    private func addAction(plantId: String, actionType: ActionType, note: String, image: UIImage? = nil) {
        let action = CareAction(context: PersistenceController.shared.container.viewContext)
        action.plantId = plantId
        action.note = note
        action.timestamp = Date()
        switch actionType {
        case .water:
            action.actionDescription = "Watered on \(action.dateString())"
        case .fertilize:
            action.actionDescription = "Fertilized on \(action.dateString())"
        case .takePicture:
            action.actionDescription = "Taked picture on \(action.dateString())"
            action.image = image?.pngData()
        case .repoding:
            action.actionDescription = "Repotted on \(action.dateString())"
        }
        
        try? action.managedObjectContext?.save()
    }
    
    func reCreateData() {
        fetch()
        items.forEach{$0.delete()}
        
        let names = ["Endless Summer", "Penoy","Tulip", "Hyacinth","Chrysanthemum", "Rose","Lily", "Orchid"]
        let locations = ["Living Room", "Balcony", "Bath Room", "Bed Room"]
        let viewContext = PersistenceController.shared.container.viewContext
        for _ in 1...10 {
            let plant = Plant(context: viewContext)
            plant.id = UUID().uuidString
            plant.name = names[Int.random(in: 0..<names.count)]
            plant.location = locations[Int.random(in: 0..<locations.count)]
            plant.timestamp = Calendar.current.date(byAdding: .day, value: Int.random(in: -40 ..< -15), to: Date())!
            plant.waterSchedule = 10
            plant.fertilizeSchedule = 30
            plant.note = "I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note I am a note"
            plant.lastWaterDate = Calendar.current.date(byAdding: .day, value: Int.random(in: -10..<0), to: Date())!
            plant.lastFertilizeDate = Calendar.current.date(byAdding: .day, value: Int.random(in: -25..<0), to: Date())!
            
        }

        do {
            try viewContext.save()
        }catch{
        }
    }
}
