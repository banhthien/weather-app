import Foundation

class DateConverter {
    private let timezone: Double
    init(timezone: Int) {
        self.timezone = Double(timezone)
    }
    func convertDateFromUTC(dt: Int) -> Date {
        let utcDate = Date(timeIntervalSince1970: TimeInterval(dt))
//        let utcDate = convertDate(from: string)
        return utcDate.addingTimeInterval(self.timezone)
    }
    private func convertDate(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: string) ?? Date()
    }
}
