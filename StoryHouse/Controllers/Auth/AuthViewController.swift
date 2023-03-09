//
//  AuthViewController.swift
//  StoryHouse
//
//  Created by kmsoft on 06/03/23.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpLoginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var isLogin: Bool = true
    
    static func getInstance() -> AuthViewController {
        return Constant.Storyboard.AUTH.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isLogin {
            self.signInLabel.text = "Sing In"
            self.signUpLoginButton.setTitle("Tap To Create User", for: .normal)
            self.signInButton.setTitle("Sign In", for: .normal)
        } else {
            self.signInLabel.text = "Sign Up"
            self.signUpLoginButton.setTitle("Tap To Sign In", for: .normal)
            self.signInButton.setTitle("Create User", for: .normal)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        if email.isEmpty {
            Utility.alert(message: "Please enter email id.")
        } else if password.isEmpty {
            Utility.alert(message: "Please enter password.")
        } else if !Utility.isValidEmail(email) {
            Utility.alert(message: "Please enter valid email address.")
        } else {
            if self.isLogin {
                self.loginWithFirebase(email: email, password: password)
            } else {
                self.createUserWithFirebase(email: email, password: password)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if self.isLogin {
            self.isLogin = false
            self.signInLabel.text = "Sign Up"
            self.signUpLoginButton.setTitle("Tap To Sign In", for: .normal)
            self.signInButton.setTitle("Create User", for: .normal)
        } else {
            self.isLogin = true
            self.signInLabel.text = "Sign in"
            self.signUpLoginButton.setTitle("Tap To Create User", for: .normal)
            self.signInButton.setTitle("Sign In", for: .normal)
        }
    }

}

extension AuthViewController {
    
    func createUserWithFirebase(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let tempError = error as NSError? {
                switch AuthErrorCode.Code(rawValue: tempError.code) {
                case .operationNotAllowed:
                  // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    break;
                case .emailAlreadyInUse:
                  // Error: The email address is already in use by another account.
                    break;
                case .invalidEmail:
                  // Error: The email address is badly formatted.
                    break;
                case .weakPassword:
                  // Error: The password must be 6 characters long or more.
                    break;
                default:
                    break;
                }
            } else {
                let newUserInfo = Auth.auth().currentUser
//                let email = newUserInfo?.email
                let uid = newUserInfo?.uid ?? ""
                let credit = 0
                let user = User(uid: uid, credit: credit, createdAt: Date().timeIntervalSince1970, updatedAt: Date().timeIntervalSince1970)
                User.saveToFirebase(user: user)
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func loginWithFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let tempError = error as NSError? {
            switch AuthErrorCode.Code(rawValue: tempError.code) {
            case .operationNotAllowed:
              // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                break;
            case .userDisabled:
              // Error: The user account has been disabled by an administrator.
                break;
            case .wrongPassword:
              // Error: The password is invalid or the user does not have a password.
                break;
            case .invalidEmail:
              // Error: Indicates the email address is malformed.
                break;
            default:
                print("Error: \(tempError.localizedDescription)")
                break;
            }
          } else {
            print("User signs in successfully")
              let newUserInfo = Auth.auth().currentUser
//                let email = newUserInfo?.email
              let uid = newUserInfo?.uid ?? ""
              let credit = 0
              let user = User(uid: uid, credit: credit, createdAt: Date().timeIntervalSince1970, updatedAt: Date().timeIntervalSince1970)
              User.saveToFirebase(user: user)
              self.navigationController?.popViewController(animated: false)
          }
        }
    }
    
}
