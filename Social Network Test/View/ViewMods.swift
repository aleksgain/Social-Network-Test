//
//  ViewMods.swift
//  Social Network Test
//
//  Created by Alexey Gain on 4/17/18.
//  Copyright © 2018 Alexey Gain. All rights reserved.
//

import UIKit

class ViewMods: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
}
