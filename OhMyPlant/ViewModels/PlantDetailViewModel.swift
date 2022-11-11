//
//  PlantDetailViewModel.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-20.
//

import Foundation
import UIKit

enum ActionType: String {
    case water, fertilize, takePicture, repoding
}

final class PlantDetailViewModel: ObservableObject {
    
    @Published var actions: [ActionViewModel] = []
    
    private let context = PersistenceController.shared.container.viewContext
    
    func fetchActions(plantId: String) {
        let request = CareAction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.predicate = NSPredicate(format: "plantId=%@", plantId)
        
        let fetchResult = try? context.fetch(request)
        actions.removeAll()
        actions += fetchResult?.map { ActionViewModel(action: $0) } ?? []
    }
}
