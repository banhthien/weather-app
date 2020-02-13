import UIKit

class CurrentWeather: Weather, WeatherPresentable {
    var temperatureMaxText: String {
        return maxTemperature
    }
    var temperatureMinText: String {
        return minTemperature
    }
    var icon: String {
        return iconName
    }
    var dateText: String {
        return self.date.getDayOfWeek()
    }
    var temperatureText: String {
        return temperature
    }
    let condition: String
    init(iconName: String, temperature: Double, minTemperature: Double, maxTemperature: Double, condition: String, date: Date) {
        self.condition = condition
        super.init(iconName: iconName, temperature: temperature, minTemperature: minTemperature, maxTemperature: maxTemperature, date: date)
    }
}
