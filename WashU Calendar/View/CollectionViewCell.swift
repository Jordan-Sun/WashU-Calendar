//
//  CollectionViewCell.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/28.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static let reuseIdentifier = "sectionViewCell"
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

}
