import UIKit

class WhiteViewController: UIViewController {
  @IBOutlet weak var levelLabel: UILabel?
  var currentValue = 0

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)

    if !LightRoomClient.sharedClient.isConnected {
      presentViewController(DiscoveryViewController.create(), animated: true, completion: .None)
    }
  }

  @IBAction func levelChanged(sender: UISlider) {
    let value = Int(round(sender.value))
    if value != currentValue {
      currentValue = value
      levelLabel?.text = "\(value)%"
      LightRoomClient.sharedClient.setWhiteLevel(currentValue) { }
    }
  }
}
