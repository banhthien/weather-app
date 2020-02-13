import UIKit
import CoreLocation

let UIAppDelegate = UIApplication.shared.delegate as! AppDelegate

class PageViewController: UIViewController {
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let mainStroryboard = UIStoryboard(name: "Main", bundle: nil)
    private var pageControl = UIPageControl()
    private var cachedWeatherViewControllers = NSCache<NSNumber, WeatherViewController>()
    private var userLocationList = [Location](){
        didSet {
            self.pageControl.numberOfPages = userLocationList.count
        }
    }
    var lastViewedPageIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.userLocationList.insert(UIAppDelegate.listLocation[0], at: lastViewedPageIndex)
        self.view.backgroundColor = .clear
    }
}
