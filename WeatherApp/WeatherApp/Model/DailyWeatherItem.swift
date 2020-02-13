import UIKit

class DailyWeatherItem: Weather, WeatherPresentable {
    var temperatureMaxText: String {
        return maxTemperature
    }
    var temperatureMinText: String {
        return minTemperature
    }
    var icon: String {
        return iconName
    }
    var temperatureText: String {
        return temperature
    }
    var dateText: String {
        return self.date.getDayOfWeek()
    }
    init(iconName: String, date: Date, maxTemperature: Double, minTemperature: Double) {
        super.init(iconName: iconName, temperature: 0, minTemperature: minTemperature, maxTemperature: maxTemperature, date: date)
    }
}
