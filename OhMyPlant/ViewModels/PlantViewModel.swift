//
//  PlantViewModel.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-12.
//

import Foundation
import CoreData
import UIKit

final class PlantViewModel: ObservableObject {
  
    let viewContext: NSManagedObjectContext?
    private var plant: Plant
    
    private(set) var image: UIImage
    
    init(_ plant: Plant) {
        self.plant = plant
        self.viewContext = plant.managedObjectContext
        self.image = UIImage(data: plant.image ?? Data()) ?? UIImage(named: "default_plant")!
    }
    
    convenience init() {
        self.init(Plant(context: PersistenceController.shared.container.viewContext))
    }
    
    @discardableResult
    convenience init(image: Data?, name: String, location: String, daysToWater: Int, daysToFertilize: Int, note: String) {
        let plant = Plant(context: PersistenceController.shared.container.viewContext)
        plant.id = UUID().uuidString
        plant.image = image
        plant.name = name
        plant.location = location
        plant.waterSchedule = Double(daysToWater)
        plant.fertilizeSchedule = Double(daysToWater)
        plant.note = note
        
        self.init(plant)
        save()
        
        NotificationManager.update(plantId: plant.id, timeInterval: daysToWater, title: plant.name, notificationType: .water)
        NotificationManager.update(plantId: plant.id, timeInterval: daysToFertilize, title: plant.name, notificationType: .fertilize)
    }
    
    
    @discardableResult
    func save() -> Bool {
        guard viewContext?.hasChanges ?? false else {return false}
        do {
            try viewContext?.save()
            return true
        } catch {
            return false
        }
    }
    
    
    @discardableResult
    func watering() -> Bool {
        plant.lastWaterDate = Date()
        do {
            try viewContext?.save()
            return true
        } catch {
            return false
        }
    }
    @discardableResult
    func fertilizing() -> Bool {
        plant.lastFertilizeDate = Date()
        do {
            try viewContext?.save()
            return true
        } catch {
            return false
        }
    }
}


extension PlantViewModel: PlantModelProtocol {
    var id: String {
        plant.id
    }
    
    var isDead: Bool {
        get {plant.isDead}
        set {plant.isDead = newValue}
    }
    
    var name: String {
        get {plant.name}
        set {plant.name = newValue.trimmingCharacters(in: .whitespacesAndNewlines)}
    }
    
    
    var location: String {
        get{plant.location}
        set{plant.location = newValue.trimmingCharacters(in: .whitespacesAndNewlines)}
    }
    
    var daysToFertilize: Int? {
        plant.fertilizeSchedule != 0 ? Int(plant.fertilizeSchedule) - daysBetween(start: plant.lastFertilizeDate ?? plant.timestamp, end: Date()) : nil
    }
    
    var daysToWater: Int? {
        plant.waterSchedule != 0 ? Int(plant.waterSchedule) - daysBetween(start: plant.lastWaterDate ?? plant.timestamp, end: Date()) : nil
    }
    
    var daysToFertilizeDescription: String {
        "Fertilized: \(daysBetween(start: plant.lastFertilizeDate ?? plant.timestamp, end: Date())) days ago, \(daysToString(daysToFertilize))"
    }
    
    var daysToWaterDescription: String {
        "Watered: \(daysBetween(start: plant.lastWaterDate ?? plant.timestamp, end: Date())) days ago, \(daysToString(daysToWater))"
    }
    
    
    private func daysToString(_ days: Int?) -> String {
        guard let days = days else {
            return "NO PLAN"
        }
        if days < 0 {
            return "\(abs(days)) passed scheduled"
        } else if days == 0 {
            return "scheduled today"
        } else if days == 1 {
            return "scheduled tomorrow"
        }
        return "\(abs(days)) days until scheduled"
    }
    
    private func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    var note: String? {
        get {plant.note}
        set {plant.note = newValue}
    }
    
    var daysYouTakecare: Int {
        daysBetween(start: plant.timestamp, end: Date())
    }
    
    var waterSchedule: Double {
        get {plant.waterSchedule}
        set {plant.waterSchedule = newValue}
    }
    
    var fertilizeSchedule: Double {
        get {plant.fertilizeSchedule}
        set {plant.fertilizeSchedule = newValue}
    }
    
}


extension PlantViewModel: CoreDataDeleteableProtocol {
    @discardableResult
    func delete() -> Bool {
        viewContext?.delete(plant)
        do {
            try viewContext?.save()
            return true
        } catch {
            return false
        }
    }
}
