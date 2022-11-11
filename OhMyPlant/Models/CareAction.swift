//
//  CareAction.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-20.
//

import Foundation


extension CareAction {
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: timestamp ?? Date())
    }
}
