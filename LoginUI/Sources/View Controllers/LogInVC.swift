//
//  LogInVC.swift
//  LoginUI
//
//  Created by Vinay Dadwal on 04/10/22.
//

import UIKit
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit

class LogInVC: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var btForgotPassword: UIButton!
    @IBOutlet weak var btLogIn: UIButton!
    @IBOutlet weak var btFacebookLogIn: UIButton!
    @IBOutlet weak var btGoogleLogIn: GIDSignInButton!
    @IBOutlet weak var btLogInApple: ASAuthorizationAppleIDButton!
    
    //MARK: Variables
    let signInConfig = GIDConfiguration(clientID: "636151223991-avgvv3d07g8vmb0ssf2tfocm97u1e71k.apps.googleusercontent.com")
    private var appleToken: String?
    private var userID: String?
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        btLogInApple.addTarget(self, action: #selector(btAppleLogIn), for: .touchUpInside)
    }
    
    //MARK: Button Actions
    @IBAction func btLogin(_ sender: UIButton) {
        
    }
    
    @IBAction func btFBLogin(_ sender: UIButton) {
        facebookLogin()
    }
    
    @IBAction func btGoogleLogin(_ sender: Any) {
        handleSignInButton()
    }
    
    @objc func btAppleLogIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    //MARK: Functions
    func handleSignInButton() {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            let emailAddress = user.profile?.email
            print("Email: \(emailAddress ?? "")")
            
            let fullName = user.profile?.name
            print("Full Name: \(fullName ?? "")")
            
            
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            print(profilePicUrl as Any)
            // If sign in succeeded, display the app's main content View.
            
            user.authentication.do { authentication, error in
                guard error == nil else { return }
                guard let authentication = authentication else { return }
                
                let idToken = authentication.idToken
                print("idToken: \(idToken ?? "")")
                // Send ID token to backend (example below).
            }
        }
    }
}

// MARK: - Apple Login
extension LogInVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

// MARK: - Facebook Login
extension LogInVC {
    private func facebookLogin() {
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: ["email"], from: self) { result, error in
            guard error == nil else {
                // Error occurred
                print(error!.localizedDescription)
                return
            }
            
            guard let result = result, !result.isCancelled else {
                return
            }
            
            Profile.loadCurrentProfile { (profile, error) in
                let token = AccessToken.current?.tokenString
            }
        }
    }
}
