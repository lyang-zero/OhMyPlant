//
//  UIApplication.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-10.
//

import Foundation
import UIKit

extension UIApplication {
    
    func endEditing(_ force: Bool) {
        UIApplication.shared.connectedScenes
            // Keep only active scenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            //keep the key window
            .first(where: \.isKeyWindow)?
            .endEditing(force)
    }
}
