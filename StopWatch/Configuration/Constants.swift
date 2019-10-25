//
//  File.swift
//  StopWatch
//
//  Created by Sriram on 19/10/19.
//  Copyright © 2019 Sriram. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct DataModel {
        struct EntityName  {
            static let lapInfoName: String = "LapInfo"
            static let timerInfoName: String = "TimerInfo"
        }
        struct FetchKey  {
            static let createdAt: String = "createdAt"
        }
        
        struct FormatString  {
            static let idFormat: String = "%K == %@"
        }
    }
    
}
