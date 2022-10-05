//
//  Extension + String.swift
//  LoginUI
//
//  Created by Yogesh Patel on 22/01/21.
//

import UIKit

//MARK: String
extension String{
    //MARK: Email & Password Validations
    func validateEmailId() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return applyPredicateOnRegex(regexStr: emailRegEx)
    }
    
    func validatePassword(mini: Int = 8, max: Int = 8) -> Bool {
        //Minimum 8 characters at least 1 Alphabet and 1 Number:
        var passRegEx = ""
        if mini >= max{
            passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(mini),}$"
        }else {
            passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(mini),\(max)}$"
        }
        return applyPredicateOnRegex(regexStr: passRegEx)
    }
    
    func applyPredicateOnRegex(regexStr: String) -> Bool{
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validateOtherString = NSPredicate(format: "SELF MATCHES %@", regexStr)
        let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
        return isValidateOtherString
    }
}

//MARK: UIViewController
extension UIViewController {
    
    
    //MARK: KeyBoard
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: UIAlerts
    public func singleButtonAlert(title: String, msg: String, button: String?, callback: @escaping(Int)-> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: button, style: .default, handler: { (_) in
             callback(1)
         }))
        
         self.present(alert, animated: true, completion: nil)
    }
}
