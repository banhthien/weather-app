import Foundation

class Weather {
    let iconName: String
    let temperature: String
    var maxTemperature: String
    var minTemperature: String
    let date: Date
    init(iconName: String, temperature: Double, minTemperature: Double, maxTemperature: Double, date: Date) {
        self.iconName = iconName
        self.temperature = "\(Int(temperature)) º"
        self.minTemperature = "\(Int(minTemperature)) º"
        self.maxTemperature = "\(Int(maxTemperature)) º"
        self.date = date
    }
}
