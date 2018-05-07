//
//  Post.swift
//  Social Network Test
//
//  Created by Alexey Gain on 5/3/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import Foundation

class Post {
    
    private var _postKey: String!
    private var _caption: String!
    private var _likes: Int!
    private var _imageUrl: String!
    
    var caption: String {
        return _caption
    }

    var likes: Int {
        return _likes
    }

    var imageUrl: String {
        return _imageUrl
    }

    var postKet: String {
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
    }
    
}
