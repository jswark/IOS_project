import UIKit

class DataFishingDetailsViewController: UIViewController {
  
  @IBOutlet weak var fishImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var status: FishingsData!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fishImageView.image = UIImage(named: "fish")
    nameLabel.text = status.location
    distanceLabel.text = FormatDisplay.distance(status.distance!)
    let earnedDate = FormatDisplay.date(status.currentFishing?.timestamp)
    dateLabel.text = "Date: \(earnedDate)"
  }
}
