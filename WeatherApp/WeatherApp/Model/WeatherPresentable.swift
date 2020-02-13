import UIKit

protocol WeatherPresentable {
    var icon: String { get }
    var temperatureText: String { get }
    var temperatureMaxText: String { get }
    var temperatureMinText: String { get }
    var dateText: String { get }
}
