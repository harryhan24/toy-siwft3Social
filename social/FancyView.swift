//
//  FancyView.swift
//  social
//
//  Created by harry on 2017. 5. 8..
//  Copyright © 2017년 harry. All rights reserved.
//

import UIKit

class FancyView: UIView {

    override func awakeFromNib() {
        //인터페이스 빌드와의 연결을 위한 메서드
        super.awakeFromNib()
        
        
        //색상 define method
        //shadow 만드는 내용
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: SHADOW_GRAY).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }

}
