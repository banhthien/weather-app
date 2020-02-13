import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var listLocation = [Location]()
    let cachedIconImages = NSCache<NSString, UIImage>()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        listLocation.append(Location.init(name: "Ho Chi Minh", locID: 1566083, avatar: "HCM", isSelected: true))
        listLocation.append(Location.init(name: "Berlin", locID: 2950158, avatar: "Berlin", isSelected: false))
        listLocation.append(Location.init(name: "Helsinki", locID: 658226, avatar: "Helsinki", isSelected: false))
        listLocation.append(Location.init(name: "London", locID: 2643743, avatar: "london", isSelected: false))
        listLocation.append(Location.init(name: "Rio", locID: 3451189, avatar: "Rio", isSelected: false))
        listLocation.append(Location.init(name: "Stockholm", locID: 2673730, avatar: "Stockholm", isSelected: false))
        listLocation.append(Location.init(name: "Tokyo", locID: 1850147, avatar: "Tokyo", isSelected: false))
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
