import UIKit

class DailyTableViewCell: UITableViewCell {
    static let identifier = "DailyTableViewCell"
    static let height: CGFloat = 44
    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.textColor = .white
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setWeatherData(from weatherItem: WeatherPresentable) {
        let convertedName = NSString(string: weatherItem.icon)
        self.dayOfWeekLabel.text = weatherItem.dateText
        self.minTempLabel.text = weatherItem.temperatureMinText
        self.maxTempLabel.text = weatherItem.temperatureMaxText
        if let wantedImage = UIAppDelegate.cachedIconImages.object(forKey: convertedName) {
            self.weatherIconImageView.image = wantedImage
        } else {
            let url = URL(string: "https://openweathermap.org/img/wn/\(convertedName)@2x.png")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.weatherIconImageView.image = UIImage(data: data!) ?? UIImage()
                    UIAppDelegate.cachedIconImages.setObject(self.weatherIconImageView.image!, forKey: convertedName)
                }
            }
        }
    }
    
}
