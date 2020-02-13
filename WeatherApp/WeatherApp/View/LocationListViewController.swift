import UIKit
protocol LocationListViewControllerDelegate: AnyObject {
    func didUpdateLocation()
}

class LocationListViewController: UIViewController {
    @IBOutlet weak var locationListTableView: UITableView!
    weak var delegate: LocationListViewControllerDelegate?
    static let identifier = "LocationListViewController"
    private let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationListTableView.delegate = self
        self.locationListTableView.dataSource = self
        self.locationListTableView.allowsMultipleSelection = true
    }
    @IBAction func actionDismissPress(_ sender: Any) {
        self.delegate?.didUpdateLocation()
        self.navigationController?.popViewController(animated: true)
    }
    func countSelectedItem() -> Int {
        var count = 0
        for location in UIAppDelegate.listLocation {
            if location.isSelected == true {
                count += 1
            }
        }
        return count
    }
}

extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIAppDelegate.listLocation[indexPath.row].isSelected = true
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if countSelectedItem() == 1 {
            return
        }
        UIAppDelegate.listLocation[indexPath.row].isSelected = false
    }
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if countSelectedItem() == 1 {
            return nil
        }
        return indexPath
    }
}

extension LocationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UIAppDelegate.listLocation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationListTableViewCell.identifier, for: indexPath)

        cell.selectionStyle = .none
        let location = UIAppDelegate.listLocation[indexPath.row]
        cell.textLabel?.text = location.name
        if UIAppDelegate.listLocation[indexPath.row].isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "City"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
