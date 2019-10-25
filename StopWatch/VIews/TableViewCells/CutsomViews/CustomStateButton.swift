//
//  CustomStateButton.swift
//  StopWatch
//
//  Created by Sriram on 19/10/19.
//  Copyright © 2019 Sriram. All rights reserved.
//

import Foundation
import UIKit

@objc enum ButtonState: Int {
    case start
    case reset
    case stop
}

@IBDesignable
class CustomStateButton: CustomRoundedButton {
    
    @IBInspectable var buttonState: ButtonState = .start {
        didSet {
            switch self.buttonState {
            case .reset:
                setTitleColor(UIColor.red, for: .normal)
                setTitle("Reset", for: .normal)
            case .start:
                setTitleColor(UIColor.green, for: .normal)
                setTitle("Start", for: .normal)
            case .stop:
                setTitleColor(UIColor.red, for: .normal)
                setTitle("Stop", for: .normal)
            }
        }
    }
}


