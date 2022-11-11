//
//  WeatherViewModel.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import Foundation
import UIKit
import CoreLocation

class WeatherViewModel: WeatherViewModelProtocol {
    
    private let apikey = "92705f8c51e8a43572a771fd6cf80741"
    
    var isWeatherLoaded: Bool {
        return weatherData != nil
    }
    
    private var weatherData: WeatherData?{
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    var city: String {
        return weatherData?.name ?? "loading.."
    }
    
    var weather: String {
        return weatherData?.weather?.first?.description ?? ""
    }
    
    var weatherBackgroundImage: UIImage {
        UIImage(systemName: "cloud")!
    }
    
    var temperature: String {
        if let temp = weatherData?.main?.temp {
            return "\(temp) ℃"
        }
        return ""
    }
    
    var temperatureRange: String {
        if let temp_max = weatherData?.main?.temp_max, let temp_min = weatherData?.main?.temp_min{
            return "L: \(temp_min) ℃, H: \(temp_max) ℃"
        }
        return ""
    }
    
    
    init(){
//        let weather = Optional([WeatherData.WeatherDescription(description: "Snowing")])
//        let main = Optional(WeatherData.TempDescription(temp: -2, temp_max: 2, temp_min: -10))
//        self.weatherData = WeatherData(weather: weather, name: "Markham", main: main)
        fetchWeather()
    }
    
    func fetchWeather(){
        
        let request = WeatherHistory.fetchRequest()
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [sort]
        let history = try? PersistenceController.shared.container.viewContext.fetch(request).first
        if let history = history {
            if let data = history.weatherData {
                self.weatherData = self.decodeFromData(data)
            }
            let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: history.timestamp!, to: Date())
            let minutes = diffComponents.minute
            
            if self.weatherData == nil || minutes == nil || minutes! > 10 {
                locationManager.requestLocation()
            }
        } else {
            locationManager.requestLocation()
        }
    }
    
    lazy var locationManager: LocationManager = {
        let manager = LocationManager()
        manager.locationUpdatedHandler = {city, location in
            self.loadWeather(city: city, location: location)
        }
        return manager
    }()
}

extension WeatherViewModel{
    
    func loadWeather(city: String, location: CLLocationCoordinate2D){
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/find?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&appid=\(apikey)") else {return}
         
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                self.weatherData = self.decodeFromData(data)
                if self.weatherData != nil {
                    let history = WeatherHistory(context: PersistenceController.shared.container.viewContext)
                    history.weatherData = data
                    history.timestamp = Date()
                    history.cityName = city
                    try? PersistenceController.shared.container.viewContext.save()
                }
            }
        }.resume()
    }
    
    
    fileprivate func decodeFromData(_ data: Data) -> WeatherData? {
        if let result = try? JSONDecoder.init().decode(RequestResult.self, from: data){
            if let list = result.list {
                return list.first
            } else {
                debugPrint(result.message ?? "")
            }
        }
        return nil
    }
}

fileprivate struct RequestResult: Codable {
    let list: [WeatherData]?
    let code: Int?
    let message: String?
}

fileprivate struct WeatherData: Codable{
    struct WeatherDescription: Codable{
        let description: String?
    }
    struct TempDescription: Codable {
        let temp: Double?
        let temp_max: Double?
        let temp_min: Double?
    }
    let weather: [WeatherDescription]?
    let name: String?
    let main: TempDescription?
}

