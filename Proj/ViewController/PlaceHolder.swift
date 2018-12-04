//
//  PlaceHolder.swift
//  Proj
//
//  Created by Darkidan on 02/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit

class PlaceHolder: UITextField {

    override init(frame: CGRect){
        super.init(frame: frame)
        setUpField()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setUpField()
    }
    
    func setUpField() {
        borderStyle = .none
        layer.cornerRadius = frame.size.height/2
        backgroundColor = UIColor.white.withAlphaComponent(0.7)
        autocorrectionType = .no
        clipsToBounds = true
        
        let placeholder = self.placeholder != nil ? self.placeholder! : ""
    }

}
