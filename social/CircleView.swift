//
//  CircleView.swift
//  social
//
//  Created by harry on 2017. 5. 8..
//  Copyright © 2017년 harry. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width/2
        clipsToBounds = true
    }

}
