//
//  WeatherView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import SwiftUI

protocol WeatherViewModelProtocol: ObservableObject {
    var weatherBackgroundImage: UIImage { get }
    var temperature: String { get }
    var temperatureRange: String { get }
    var city: String { get }
    var weather: String { get }
}

struct WeatherView<ViewModel: WeatherViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Color.systemBackground
            } else {
                appState.mainThemeColor
            }
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.temperature)
                            .font(.title2)
                        
                        Text(viewModel.temperatureRange)
                            .font(.subheadline)
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(viewModel.city)
                            .font(.title2)
                            .lineLimit(1)
                        
                        Text(viewModel.weather)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel())
            .environmentObject(AppState.shared)
    }
}
