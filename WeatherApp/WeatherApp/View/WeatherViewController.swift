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
    var index = 0
    var height : CGFloat = 44.0
    // MARK: ViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDailyTableViewCells()
//        self.dailyTableView.dataSource = self
//        self.dailyTableView.delegate = self
        self.dailyTableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func registerDailyTableViewCells() {
        let dailyTableViewCellNib = UINib(nibName: DailyTableViewCell.identifier, bundle: nil)
        dailyTableView.register(dailyTableViewCellNib, forCellReuseIdentifier: DailyTableViewCell.identifier)
    }
    @IBAction func actionChooseLocation(_ sender: Any) {
        self.delegate?.didSelectLocationList()
    }
}
