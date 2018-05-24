//
//  User.swift
//  Social Network Test
//
//  Created by Alexey Gain on 5/3/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import Foundation

class UserInf {
    
    private var _email: String!
    private var _name: String!
    private var _provider: String!
    private var _userpic: String!
    
    var email: String {
        return _email
    }
    
    var name: String {
        return _name
    }
    
    var provider: String {
        return _provider
    }
    
    var userpic: String {
        return _userpic
    }
    
    init() {
      self._email = ""
        self._name = ""
        self._provider = ""
        self._userpic = ""
    }
    
    init(userData: Dictionary<String, AnyObject>) {
        

        if let email = userData["email"] as? String {
            self._email = email
        } else {
            self._email = ""
        }
        
        if let name = userData["name"] as? String {
            self._name = name
        } else {
            self._name = ""
        }
        
        if let provider = userData["provider"] as? String {
            self._provider = provider
        } else {
            self._provider = ""
        }
        
        if let userpic = userData["userpic"] as? String {
            self._userpic = userpic
        } else {
            self._userpic = ""
        }
        
    }
    
}
