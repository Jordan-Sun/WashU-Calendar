//
//  ScrollViewDelegate.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/29.
//  Copyright © 2020 washu. All rights reserved.
//

import UIKit

class DayScrollViewDelegate: NSObject {
    
    /// Collection view scroll view current y
    var currentY: CGFloat = 480
    
}

extension DayScrollViewDelegate: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentY = scrollView.contentOffset.y
    }
    
}
