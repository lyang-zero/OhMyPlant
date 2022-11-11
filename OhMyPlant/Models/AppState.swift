//
//  AppState.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-10.
//

import SwiftUI

final class AppState: ObservableObject {
    static let shared = AppState()
    
    var weather: WeatherState = .Sunny
    
    var mainThemeColor: Color {
        Color.mainThemeColor(weather: weather)
    }
}
