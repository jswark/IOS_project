import Foundation
import UIKit

extension UIColor {

    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class LoginVC : UIViewController {
    
    
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var loginField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var signUpBt: UIButton!

    @IBOutlet weak var signInBt: UIButton!

    @IBOutlet weak var restorePasswordBt: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(rgb: 0xcfe2f3)
        setUpUI()
    }
    
    private func setUpUI () {
        loginField.placeholder = "Login"
        passwordField.placeholder = "Password"
        

        signUpBt.setTitle("Sign up", for: .normal)
        signInBt.setTitle("Sign in", for: .normal)
        restorePasswordBt.setTitle("Restore password", for: .normal)
        
        var logoImage: UIImage = UIImage(named: "transfer")!
        backgroundImage.image = logoImage
    }
}
