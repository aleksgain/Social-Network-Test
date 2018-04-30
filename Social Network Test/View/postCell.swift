//
//  postCell.swift
//  Social Network Test
//
//  Created by Alexey Gain on 4/27/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import UIKit

class postCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likes: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
