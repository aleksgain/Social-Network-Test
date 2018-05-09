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

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likes: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.caption.text = post.caption
        self.likes.text = "\(post.likes)"
        
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
    }
    
}
