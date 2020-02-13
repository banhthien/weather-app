import Foundation

class WeatherBuilder {
    private let data: WeatherData
    private var utcTimeConverter: DateConverter
    init(data: WeatherData) {
        self.data = data
        self.utcTimeConverter = DateConverter(timezone: data.city.timezone)
    }
    func getCurrentWeather() -> CurrentWeather {
        let weather = data.list[0].weather[0]
        let firstListItem = data.list[0]
        let convertedDate = utcTimeConverter.convertDateFromUTC(dt: firstListItem.dt)
        return CurrentWeather(iconName: weather.icon, temperature: firstListItem.temp.day, minTemperature: firstListItem.temp.tempMin, maxTemperature: firstListItem.temp.tempMax, condition: weather.description, date: convertedDate)
    }
    func getDailyWeatherItems() -> [DailyWeatherItem] { // date, icon, temperature-min/max
        var minTemperature = [String: Double]()
        var maxTemperature = [String: Double]()
        var firstDate = [String: Date]()
        var firstIcon = [String: String]()
        for item in data.list {
            let dayOfWeek = utcTimeConverter.convertDateFromUTC(dt: item.dt).getDayOfWeek()
            minTemperature.merge([dayOfWeek: item.temp.tempMin]) { return $0 > $1 ? $1 : $0 }
            maxTemperature.merge([dayOfWeek: item.temp.tempMax]) { return $0 > $1 ? $0 : $1 }
            firstDate.merge([dayOfWeek: utcTimeConverter.convertDateFromUTC(dt: item.dt)]) { (first, second) in first }
            firstIcon.merge([dayOfWeek: item.weather[0].icon]) { (first, second) in first }
        }
        var dailyWeatherItems = [DailyWeatherItem]()
        for key in minTemperature.keys {
            let dailyWeatherItem = DailyWeatherItem(iconName: firstIcon[key]!, date: firstDate[key]!, maxTemperature: maxTemperature[key]!, minTemperature: minTemperature[key]!)
            dailyWeatherItems.append(dailyWeatherItem)
        }
        return dailyWeatherItems.sorted(by: { (first, second) in
            first.date < second.date
        })
    }
}
