import Foundation

class WeatherViewModel {
    var location: Observable<Location>
    let currentWeather: Observable<CurrentWeather>
    let dailyWeatherItems: Observable<[DailyWeatherItem]>
    init(location: Location) {
        self.location = Observable(location)
        self.currentWeather = Observable(nil)
        self.dailyWeatherItems = Observable([])
    }
    func retrieveWeatherData() {
        guard let location = location.value else {
            return
        }
        OpenWeatherMapService.retrieveWeatherInfo(using: location) { (weather, error) in
            guard let weatherData = weather, error == nil else {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async {
                self.update(using: weatherData)
            }
        }
    }
    func update(using data: WeatherData) {
        if self.location.value?.name == nil {
            self.location.value?.name = data.city.name
        }
        let weatherBuilder = WeatherBuilder(data: data)
        currentWeather.value = weatherBuilder.getCurrentWeather()
        dailyWeatherItems.value = weatherBuilder.getDailyWeatherItems()
    }
}
