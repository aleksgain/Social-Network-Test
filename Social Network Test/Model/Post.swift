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
