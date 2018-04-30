//
//  roundImg.swift
//  Social Network Test
//
//  Created by Alexey Gain on 4/27/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width/2
        clipsToBounds = true
    }
}
