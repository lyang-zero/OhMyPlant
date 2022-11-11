//
//  Color+UIColor+Weather.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-10.
//

import SwiftUI

public enum WeatherState {
    case Cloudy, Sunny, Raining, Windy, Snowing, Storm
}

public extension Color {
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)

    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)

    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    init(light: Color, dark: Color) {
        self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
    
    static func mainThemeColor(weather: WeatherState) -> Color {
        switch weather {
        case .Cloudy:
            return Color(light: .darkText, dark: .white)
        case .Sunny:
            return Color(light: .cyan, dark: .white)
        case .Raining:
            return Color(light: .green, dark: .white)
        case .Windy:
            return Color(light: .purple, dark: .white)
        case .Snowing:
            return Color(light: .cyan, dark: .white)
        case .Storm:
            return Color(light: .cyan, dark: .white)
        }
    }
}

extension UIColor {
  convenience init(light: UIColor, dark: UIColor) {
    self.init { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .light, .unspecified:
        return light
      case .dark:
        return dark
      @unknown default:
        return light
      }
    }
  }
}
