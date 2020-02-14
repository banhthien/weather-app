import UIKit
import CoreLocation

protocol WeatherViewControllerDelegate: AnyObject {
    func didSelectLocationList()
}

class WeatherViewController: UIViewController {
    static let identifier = "WeatherViewController"
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var minTemLabel: UILabel!
    @IBOutlet weak var maxTemLabel: UILabel!
    @IBOutlet weak var iconState: UIImageView!
    weak var delegate: WeatherViewControllerDelegate?
    var location : Location!
    var index = 0
    var height : CGFloat = 44.0
    // MARK: ViewModel
    var viewModel: WeatherViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            viewModel.location.observe { [unowned self] in
                self.cityLabel.text = $0.name
            }
            viewModel.currentWeather.observe { [unowned self] in
                self.conditionLabel.text = $0.condition
                self.temperatureLabel.text = $0.temperature
                self.minTemLabel.text = $0.minTemperature
                self.maxTemLabel.text = $0.maxTemperature
                let convertedName = NSString(string: $0.icon)
                if let wantedImage = UIAppDelegate.cachedIconImages.object(forKey: convertedName) {
                    self.iconState.image = wantedImage
                } else {
                    let url = URL(string: "https://openweathermap.org/img/wn/\(convertedName)@2x.png")
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.iconState.image = UIImage(data: data!) ?? UIImage()
                            UIAppDelegate.cachedIconImages.setObject(self.iconState.image!, forKey: convertedName)
                        }
                    }
                }
            }
            viewModel.dailyWeatherItems.observe { [unowned self] list in
                self.dailyTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDailyTableViewCells()
        self.dailyTableView.dataSource = self
        self.dailyTableView.delegate = self
        self.dailyTableView.separatorStyle = .none
        if let cityName = location?.name {
            self.cityLabel.text = cityName
        }
        getWeatherData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundImage.image = UIImage(named: location.avatar)
    }
    private func registerDailyTableViewCells() {
        let dailyTableViewCellNib = UINib(nibName: DailyTableViewCell.identifier, bundle: nil)
        dailyTableView.register(dailyTableViewCellNib, forCellReuseIdentifier: DailyTableViewCell.identifier)
    }
    @IBAction func actionChooseLocation(_ sender: Any) {
        self.delegate?.didSelectLocationList()
    }
    private func getWeatherData() {
        self.viewModel = WeatherViewModel(location: location)
        self.viewModel?.retrieveWeatherData()
    }
}

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.dailyWeatherItems.value?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell,
            let weatherItem = viewModel?.dailyWeatherItems.value?[indexPath.row] else {
                return DailyTableViewCell()
        }
        cell.setWeatherData(from: weatherItem)
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height
    }
}
