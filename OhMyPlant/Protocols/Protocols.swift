//
//  Protocols.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-12.
//

import Foundation
import CoreData
import SwiftUI

protocol BasicPlantModelProtocol: Identifiable {
    var name: String {get set}
    var image: UIImage {get}
    var location: String {get set}
    var daysToFertilizeDescription: String {get}
    var daysToWaterDescription: String{get}
}

protocol PlantModelProtocol: BasicPlantModelProtocol {
    var id: String {get}
    var note: String? {get set}
    var daysYouTakecare: Int {get }
    var daysToWater: Int? {get}
    var daysToFertilize: Int?{get}
    var waterSchedule: Double{get set}
    var fertilizeSchedule: Double{get set}
    var isDead: Bool{get set}
}

protocol CoreDataDeleteableProtocol {
    @discardableResult
    func delete() -> Bool
}


