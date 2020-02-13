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
}
