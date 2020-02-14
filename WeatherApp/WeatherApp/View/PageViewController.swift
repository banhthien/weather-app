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
        configureSubViews()
        self.userLocationList.insert(UIAppDelegate.listLocation[0], at: lastViewedPageIndex)
        let currentWeatherViewController = weatherViewController(at: lastViewedPageIndex)
        self.pageViewController.setViewControllers([currentWeatherViewController], direction: .forward, animated: false, completion: nil)
        self.view.backgroundColor = .clear
    }
    private func configureSubViews() {
        let pageViewFrame = self.view.frame
        configurePageViewController(inside: pageViewFrame)
    }
    private func configurePageViewController(inside frame: CGRect) {
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        let weatherViewRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.pageViewController.view.frame = weatherViewRect
        self.pageViewController.didMove(toParent: self)
    }
    func userDidSelectLocation(at index: Int) {
        guard let weatherViewController = weatherViewController(at: index) as? WeatherViewController else {
            print(CreationError.toWeatherViewController)
            return
        }
        self.pageViewController.setViewControllers([weatherViewController], direction: .forward, animated: false, completion: nil)
        self.pageControl.currentPage = index
        self.lastViewedPageIndex = index
    }
    // Remove view
    func userDeleteLocation(at deletingIndex: Int) {
        if self.lastViewedPageIndex == deletingIndex {
            self.lastViewedPageIndex = 0
        }
        if self.lastViewedPageIndex > deletingIndex {
            self.lastViewedPageIndex -= 1
        }
        removeLocation(at: deletingIndex)
        changeIndexOfCachedWeatherViewControllers(after: deletingIndex)
        userDidSelectLocation(at: lastViewedPageIndex)
    }
    // Remove Location obj
    private func removeLocation(at index: Int) {
        self.userLocationList.remove(at: index)
        self.cachedWeatherViewControllers.removeObject(forKey: NSNumber(value: index))
    }
    // change Index Of Cached Weather
    private func changeIndexOfCachedWeatherViewControllers(after deletingIndex: Int) {
        var needChangeIndex = deletingIndex + 1
        repeat {
            let targetIndex = NSNumber(value: needChangeIndex)
            if let indexChangingViewController = self.cachedWeatherViewControllers.object(forKey: targetIndex) {
                self.cachedWeatherViewControllers.removeObject(forKey: targetIndex)
                indexChangingViewController.index -= 1
                self.cachedWeatherViewControllers.setObject(indexChangingViewController, forKey: NSNumber(value: indexChangingViewController.index))
            }
            needChangeIndex += 1
        } while needChangeIndex <= userLocationList.count
    }
    func checkLocationList() {
        for location in UIAppDelegate.listLocation {
            if location.isSelected == true {
                var isNew = true
                for oldLocation in userLocationList {
                    if location.locID == oldLocation.locID {
                        isNew = false
                    }
                }
                if isNew {
                    userLocationList.append(location)
                }
            }
        }
    }
}

// MARK: page view controller delegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let displayedContentViewController = pageViewController.viewControllers?[0] as? WeatherViewController else {
            return
        }
        self.pageControl.currentPage = displayedContentViewController.index
        self.lastViewedPageIndex = displayedContentViewController.index
    }
}

// MARK: page view controller data source
extension PageViewController: UIPageViewControllerDataSource {
    func weatherViewController(at index: Int) -> UIViewController {
        if let cachedWeatherViewController = cachedWeatherViewControllers.object(forKey: NSNumber(value: index)) {
            return cachedWeatherViewController
        }
        guard let createdWeatherViewController = mainStroryboard.instantiateViewController(withIdentifier: WeatherViewController.identifier) as? WeatherViewController else {
            CreationError.toWeatherViewController.andReturn()
        }
        createdWeatherViewController.delegate = self
        if userLocationList.count == 0 {
            checkLocationList()
            createdWeatherViewController.location = userLocationList[index]
        } else if userLocationList.count >= index + 1 {
            createdWeatherViewController.location = userLocationList[index]
        }
        
        createdWeatherViewController.index = index
        cachedWeatherViewControllers.setObject(createdWeatherViewController, forKey: NSNumber(value: index))
        return createdWeatherViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? WeatherViewController {
            let currentIndex = viewController.index
            return currentIndex > 0 ? weatherViewController(at: currentIndex - 1) : nil
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? WeatherViewController {
            let currentIndex = viewController.index
            return currentIndex < pageControl.numberOfPages - 1 ? weatherViewController(at: currentIndex + 1) : nil
        }
        return nil
    }
}

extension PageViewController: WeatherViewControllerDelegate {
    func didSelectLocationList() {
        guard let locationListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LocationListViewController.identifier) as? LocationListViewController else {
            return
        }
        locationListViewController.delegate = self
        self.navigationController?.pushViewController(locationListViewController, animated: true)
    }
}

extension PageViewController: LocationListViewControllerDelegate {
    func didUpdateLocation() {
        // remove old location
        var tIndex = 0
        var removeList = [Int]()
        for oldLocation in userLocationList {
            var isRemove = true
            for location in UIAppDelegate.listLocation {
                if location.locID == oldLocation.locID && location.isSelected {
                    isRemove = false
                }
            }
            if isRemove {
                removeList.append(tIndex)
            }
            tIndex += 1
        }
        removeList.sort(){ $0 > $1 }
        for index in removeList {
            userDeleteLocation(at: index)
        }
        // insert new location
        checkLocationList()
        userDidSelectLocation(at: lastViewedPageIndex)
    }
}
