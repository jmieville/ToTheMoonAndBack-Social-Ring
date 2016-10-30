//
//  ViewController.swift
//  Social Ring
//
//  Created by Jean-Marc Kampol Mieville on 10/26/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper



class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func signInFirebase(_ sender: AnyObject) {
        if let email = emailField.text, let password = passwordField.text {
            let email = emailField.text
            let password = passwordField.text
            firebaseAuthEmailPass(email: email!, password: password!)
            

        } else {
            print("Please put your email and password correctly.")
        }
        
    }
    

    
    @IBOutlet weak var emailField: UITextField!
    
    @IBAction func dismissKeyboardTap(_ sender: AnyObject) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            self.performSegue(withIdentifier: "GoToFeed", sender: nil)
        }
        
        
        
        emailField?.delegate = self
        passwordField?.delegate = self
        
    
        
        
        if let accessToken = AccessToken.current {
            let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
            loginButton.center = view.center
            view.addSubview(loginButton)
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)
            print("Getting the \(credential)")
            self.firebaseAuth(credential)
            

        } else {
            let loginButton = LoginButton(readPermissions: [ .publicProfile ])
            loginButton.center = view.center
            view.addSubview(loginButton)
            print("proceed to log-in")
        }
        
//        func textFieldShouldReturn(textField: UITextField) -> Bool {
//            self.emailField.resignFirstResponder()
//            self.passwordField.resignFirstResponder()
//            return true
//        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if error != nil {
                print("\(user?.email) unsuccessfully log in with firebase - \(error)")
            } else {
                print("\(user?.email) successfully logged in with firebase - \(error)")
                self.completeSignIn(id: (user?.uid)!)
                self.goToFeedIfLoggedIn()

            }
        }
        
    }
    
    func goToFeedIfLoggedIn() {
        self.performSegue(withIdentifier: "GoToFeed", sender: nil)
    }
    
    func completeSignIn(id: String) {
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Data saved to key chain \(keyChainResult)")
    }
    
    func firebaseAuthEmailPass(email: String, password: String){
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
            if error != nil {
                print("\(user?.email) unsuccessfully log in with firebase - \(error)")
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        print("Failed to create user")
                    } else {
                        print("Successfully created user")
                        self.completeSignIn(id: (user?.uid)!)
                        self.goToFeedIfLoggedIn()

                        
                    }
                })
            } else {
                print("\(user?.email) successfully logged in with firebase - \(error)")
                self.goToFeedIfLoggedIn()

            }
        })
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        self.view.endEditing(true)
    }
    

}

