//
//  Post.swift
//  Social Network Test
//
//  Created by Alexey Gain on 5/3/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _postKey: String!
    private var _caption: String!
    private var _likes: Int!
    private var _imageUrl: String!
    private var _creatorId: String!
    private var _creatorName: String!
    private var _creatorPic: String!
    private var _postRef: DatabaseReference!
    
    var caption: String {
        return _caption
    }

    var likes: Int {
        return _likes
    }

    var imageUrl: String {
        return _imageUrl
    }

    var postKey: String {
        return _postKey
    }
    
    var creatorId: String {
        return _creatorId
    }
    
    var creatorName: String {
        return _creatorName
    }
    
    var creatorPic: String {
        return _creatorPic
    }
    
    init(caption: String, likes: Int, imageUrl: String) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
        self._caption = caption
        }

        if let imageUrl = postData["imageUrl"] as? String {
          self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
        self._likes = likes
        }
    
        if let creatorId = postData["creatorId"] as? String {
            self._creatorId = creatorId
        }
        
        if let creatorName = postData["creatorName"] as? String {
            self._creatorName = creatorName
        }
        
        if let creatorPic = postData["creatorPic"] as? String {
            self._creatorPic = creatorPic
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
                
    }
    
}
