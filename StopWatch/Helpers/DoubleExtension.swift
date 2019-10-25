//
//  DoubleExtension.swift
//  StopWatch
//
//  Created by Sriram on 19/10/19.
//  Copyright © 2019 Sriram. All rights reserved.
//

import Foundation


extension Double {
    func convertString() -> String {
        let minutes = UInt8(self) / 60
        let seconds = UInt8(self) % 60
        let mileseconds = Int(self * 100) % 100
        return String(format:  "%02d:%02d:%02d", minutes,seconds,mileseconds)
    }
}
