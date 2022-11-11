//
//  ActionViewModel.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-20.
//

import Foundation
import UIKit
import CoreData

final class ActionViewModel: ObservableObject, Identifiable {
    
    private let action: CareAction
    
    private let viewContext: NSManagedObjectContext?
    
    init(action: CareAction){
        self.action = action
        self.image = UIImage(data: action.image ?? Data())
        self.viewContext = action.managedObjectContext
    }
    
    
    var note: String {
        get{action.note ?? ""}
        set{action.note = newValue}
    }
    
    var actionDescription: String {
        get{action.actionDescription!}
        set{action.actionDescription = newValue}
    }
    var image: UIImage?
}
