import UIKit

class SMSCodeViewController: UIViewController, UITextFieldDelegate {

  
  
    private let codeField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Phone Code"
        field.textAlignment = .center
        field.returnKeyType = .continue
        
        return field
    }()
  

  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(codeField)
        codeField.frame = CGRect(x: 0, y: 0, width: 220, height: 50)
        codeField.center = view.center
        codeField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            let code = (text)
            AuthManager.shared.verifyCode(smsCode: code){
                [weak self] success in guard success else { return}
                DispatchQueue.main.async {
                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
                  let vc = storyboard.instantiateViewController(withIdentifier: "Home")
                  self?.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        return true
    }

}



