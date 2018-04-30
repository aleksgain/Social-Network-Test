//
//  FirebaseUI.swift
//  Social Network Test
//
//  Created by Alexey Gain on 4/25/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import SwiftKeychainWrapper
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class firebaseUISignIn: UIViewController, FUIAuthDelegate {
    
    override func viewDidLoad() {
     
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        authUI?.providers = providers
        let authViewController = authUI?.authViewController()
        authUI
    }

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
}
