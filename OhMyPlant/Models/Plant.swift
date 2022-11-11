//
//  Plant.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import Foundation
import UIKit

extension Plant {
    
    public var id: String {
        get {id_ ?? ""}
        set {id_ = newValue}
    }
    
    var name: String {
        get {name_ ?? ""}
        set {name_ = newValue}
    }
    
    var timestamp: Date {
        get {timestamp_ ?? Date()}
        set {timestamp_ = newValue}
    }
    
    var location: String {
        get {location_ ?? ""}
        set {location_ = newValue}
    }
}
