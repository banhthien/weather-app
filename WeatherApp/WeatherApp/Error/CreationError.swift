import Foundation

enum CreationError: Error {
    case toWeatherViewController
    func andReturn() -> Never {
        fatalError("self")
    }
}
