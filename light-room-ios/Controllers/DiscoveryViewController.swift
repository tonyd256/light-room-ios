import UIKit

class DiscoveryViewController: UIViewController {
  private let manager = DiscoveryManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    manager.startBrowsing(found)
  }

  private func found(host: String) {
    LightRoomClient.sharedClient.setHost(host)
    manager.stopBrowsing()
    dismissViewControllerAnimated(true, .None)
  }
}

extension DiscoveryViewController {
  class func create() -> DiscoveryViewController {
      return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DiscoveryViewController") as DiscoveryViewController
  }
}
