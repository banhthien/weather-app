import Foundation

// MARK: - Weather
struct WeatherData: Codable {
    let cnt: Int
    let list: [List]
    let city: City
}
// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let country: String
    let timezone: Int
}
// MARK: - List
struct List: Codable {
    let dt: Int // Time of data forcasted
    let temp: MainClass
    let weather: [WeatherElement]
    enum CodingKeys: String, CodingKey {
        case dt, temp, weather
    }
}
// MARK: - MainClass
struct MainClass: Codable {
    let day, tempMin, tempMax: Double
    enum CodingKeys: String, CodingKey {
        case day
        case tempMin = "min"
        case tempMax = "max"
    }
}
// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
