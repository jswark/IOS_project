import UIKit

class FishingsCell: UITableViewCell {
  
  @IBOutlet weak var badgeImageView: UIImageView!
  @IBOutlet weak var silverImageView: UIImageView!
  @IBOutlet weak var goldImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var earnedLabel: UILabel!
  
  var data: FishingsData! {
    didSet {
      configure()
    }
  }
  
  private let colorGrey = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
  private let badgeRotation = CGAffineTransform(rotationAngle: .pi / 8)
  
  private func configure() {
    
    silverImageView.isHidden = true
    goldImageView.isHidden = true
    
    nameLabel.text = data.location
    nameLabel.textColor = colorGrey
    let dateEarned = FormatDisplay.date(data.currentFishing?.timestamp)
    earnedLabel.text = "Date: \(dateEarned)"
    earnedLabel.textColor = colorGrey
    badgeImageView.image = UIImage(named: "fish")
    isUserInteractionEnabled = true
    accessoryType = .disclosureIndicator
  }
}
