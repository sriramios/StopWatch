//
//  LapTableViewCell.swift
//  StopWatch
//
//  Created by Sriram on 19/10/19.
//  Copyright © 2019 Sriram. All rights reserved.
//

import Foundation
import UIKit

class LapTableViewCell: UITableViewCell {
    static let resueIdentifier: String = "LapTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    func updateView(name: String, timeInterval: String) {
        self.nameLabel.text = name
        self.timeIntervalLabel.text = timeInterval
    }
}
