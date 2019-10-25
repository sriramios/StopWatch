//
//  CustomRoundedButton.swift
//  StopWatch
//
//  Created by Sriram on 19/10/19.
//  Copyright © 2019 Sriram. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomRoundedButton: UIButton {
    
    @IBInspectable var makeRounded: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.makeRounded
        }
    }
}
