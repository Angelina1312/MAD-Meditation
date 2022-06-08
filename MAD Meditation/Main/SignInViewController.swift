//
//  ViewController.swift
//  MAD Meditation
//
//  Created by Student on 04.05.2022.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    let userDef = UserDefaults.standard
    
    @IBAction func signInAction(_ sender: UIButton) {
        
        let url = "http://mskko2021.mad.hakta.pro/api/user/login"
        let param : [String: String] = [
            "email": inputEmail.text!,
            "password": inputPassword.text!
        ]
        AF.request(url, method: .post, parameters: param, encoder: JSONParameterEncoder.default).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let token = json["token"].stringValue
                self.userDef.setValue(token, forKey: "userToken")
            case .failure(let error):
                let errorJSON = JSON(response.data)
                let errorDescription = errorJSON["error"].stringValue
                self.showAlert(message: errorDescription)
            }
        }
    
        
        guard inputPassword.text?.isEmpty == false && inputPassword.text?.isEmpty == false else {
            return showAlert(message: "Поля пустые")
            guard isValidEmail(EmailID: inputEmail.text!) else {
                return showAlert(message: "Проверьте правильность почты")
            }
        }
      }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Уведомление", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
            
  
    func isValidEmail(EmailID: String)->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: EmailID)
    }

}

