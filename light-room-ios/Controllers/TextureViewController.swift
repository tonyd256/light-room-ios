import UIKit

class TextureViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView?

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    if !LightRoomClient.sharedClient.isConnected {
      presentViewController(DiscoveryViewController.create(), animated: true, completion: .None)
    }
  }
}
