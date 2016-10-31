//
//  FeedVCViewController.swift
//  Social Ring
//
//  Created by Jean-Marc Kampol Mieville on 10/30/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin
import SwiftKeychainWrapper

class FeedVCViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userEmail: UILabel!

    @IBAction func signOutFireBase(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        self.dismiss(animated: true, completion: nil)
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: KEY_UID)


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let user =  FIRAuth.auth()?.currentUser {
            userEmail.text = user.email
        }
        
        if let accessToken = AccessToken.current {
            let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
            loginButton.center = view.center
            view.addSubview(loginButton)
            try! FIRAuth.auth()!.signOut()
            self.dismiss(animated: true, completion: nil)
        }
        
        
        

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    
    

        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
