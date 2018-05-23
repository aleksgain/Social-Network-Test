//
//  postCell.swift
//  Social Network Test
//
//  Created by Alexey Gain on 4/27/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import UIKit
import Firebase

class postCell: UITableViewCell {

    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var likeImg: CircleView!
    
    var post: Post!
    var likesRecieved: DatabaseReference!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.userName.text = post.creatorName
        self.caption.text = post.caption
        self.likes.text = "\(post.likes)"
        if let url = NSURL(string: post.creatorPic) {
            if let data = NSData(contentsOf: url as URL) {
                userPic.image = UIImage(data: data as Data)
            }
        }
        likesRecieved = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        if img != nil {
            self.postImg.image = img
        } else {
             let imageUrl = post.imageUrl
             let ref = Storage.storage().reference(forURL: imageUrl)
            ref.getData(maxSize: 20 * 1024 * 1024) { (data, error) in
                if error != nil {
                    print("Couldn't get img /n \(error.debugDescription)")
                } else {
                    print("Downloaded img from Firebase")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image  = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            }
            
        }
       
        likesRecieved.observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        }
    }
    
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        likesRecieved.observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post?.adjustLikes(addLike: true)
                self.likesRecieved.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post?.adjustLikes(addLike: false)
                self.likesRecieved.removeValue()
            }
        }
    }
    
}
