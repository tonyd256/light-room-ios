import UIKit
import LlamaKit

class TextureViewController: UIViewController, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView?

  var images: [String] = []

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    if !LightRoomClient.sharedClient.isConnected {
      presentViewController(DiscoveryViewController.create(), animated: true, completion: .None)
    } else {
      LightRoomClient.sharedClient.getTextures {
        self.images = $0 ?? []
        self.tableView?.reloadData()
      }
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return images.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as ImageCell

    LightRoomClient.sharedClient.getTexture(images[indexPath.row]) {
      cell.textureView?.image = $0.value()
      return ()
    }

    return cell
  }
}
