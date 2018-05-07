//
//  ViewController.swift
//  Social Network Test
//
//  Created by Alexey Gain on 4/16/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    
    
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassoword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        
        let googleSignIn = GIDSignIn.sharedInstance()
        
        googleSignIn?.signIn()
        
        if googleSignIn?.hasAuthInKeychain() == true {
   
        }
    }
        
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        }
        
        
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let authentication = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            self.firebaseAuth(credential)
        
        
        }
        
        
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
            //handle Google sign out
        }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Error authenticating with Firebase")
            } else {
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.signInSegue(id: user.uid, userData: userData)
                }
                print("Much success authenticating, such wow!")
            }
        })
    }
    
//        @IBAction func signInPressed(_ sender: Any) {
//            if let email = userEmail.text, let pwd = userPassoword.text {
//                Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
//                    if error == nil {
//                        print("Access granted with email login")
//                        self.signInSegue(id: (user?.uid)!)
//                    } else {
//                        Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
//                            if error == nil {
//                                print("Authenticated with email")
//                                self.signInSegue(id: (user?.uid)!)
//                            } else {
//                                let credential = EmailAuthProvider.credential(withEmail: email, password: pwd)
//                                print(credential)
//                                Auth.auth().currentUser?.link(with: credential, completion: { (user, error) in
//                                if error != nil {
//                                print("Error merging", error)
//                                    } else {
//                                        print("Merging successfull")
//                                        self.signInSegue(id: (user?.uid)!)
//                                        }
//                                    })
//
//                            }
//                        })
//                    }
//                }
//
//            }
//        }
    
    @IBAction func signInPressed(_ sender: Any) {
        if let email = userEmail.text, let pwd = userPassoword.text {
            Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
                if error == nil {
                    print("Access granted with email login")
                      let userData = ["provider": user!.providerID]
                    self.signInSegue(id: (user?.uid)!, userData: userData)
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Authentication with email failed")
                        } else {
                            print("Authenticated with email")
                              let userData = ["provider": user!.providerID]
                            self.signInSegue(id: (user?.uid)!, userData: userData)
                        }
                    })
                }
            }

        }
    }

    func signInSegue(id: String, userData: Dictionary<String, String>) {
        KeychainWrapper.standard.set(id, forKey: "uid")
        DataService.ds.createDBUser(uid: id, userData: userData)
        performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }
    
}
