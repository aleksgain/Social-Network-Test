//
//  RoundButton.swift
//  Social Network Test
//
//  Created by Alexey Gain on 4/17/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.contentMode = .scaleAspectFit
        layer.cornerRadius = 10.0
    }

}
