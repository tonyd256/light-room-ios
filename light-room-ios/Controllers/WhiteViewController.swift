import UIKit

class WhiteViewController: UIViewController {
  @IBOutlet weak var levelLabel: UILabel?

  @IBAction func levelChanged(sender: UISlider) {
    let value = Int(round(sender.value * 100))
    levelLabel?.text = "\(value)%"
  }
}
