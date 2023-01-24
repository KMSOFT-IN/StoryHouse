//
//  SplashViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit
import AuthenticationServices

class SplashViewController: UIViewController {
    
    @IBOutlet var appleSignInButton: ASAuthorizationAppleIDButton!
    private let signInButton = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.appleSignInButton.addTarget(self, action: #selector(didTapSign), for: .touchUpInside)
    }
    
    @objc func didTapSign() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    static func getInstance() -> SplashViewController {
        return Constant.Storyboard.MAIN.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
    }
    
   
    @IBAction func signInWithAppleButtontapped(_ sender: Any) {
        let viewController = ChildNameViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        guard let url = URL(string: TERMS_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
        guard let url = URL(string: PRIVACY_POLICY_URL) else { return }
        UIApplication.shared.open(url)
    }
    
}


extension SplashViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed!")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let firsName = credentials.fullName?.givenName
            let email = credentials.email
            UserDefaults.standard.setValue(email, forKey: "email")
            UserDefaults.standard.synchronize()
            print("\(String(describing: firsName))  \(String(describing: email))")
            break
        default:
            break
        }
    }
}

extension SplashViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

