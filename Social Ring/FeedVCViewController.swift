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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value) { (snapshot: FIRDataSnapshot) in
            print(snapshot.value)
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("\(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict as! Dictionary<String, AnyObject>)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()

        }

        
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

        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
//        print("\(post.caption)")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            cell.configureCell(post: post)
            return cell
        } else {
            return PostCell()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with:event)
        self.view.endEditing(true)
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
