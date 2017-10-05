//
//  KCFABWindow.swift
//  KCFloatingActionButton-Sample
//
//  Created by LeeSunhyoup on 2015. 10. 13..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

/**
    KCFloatingActionButton dependent on UIWindow.
*/
class KCFABWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.windowLevel = UIWindowLevelNormal
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let fabViewController = rootViewController as? KCFABViewController
        if let fab = fabViewController?.fab {
            if fab.closed == false {
                return true
            }
            
            if fab.frame.contains(point) == true {
                return true
            }
            
            for item in fab.items {
                let itemFrame = self.convert(item.frame, from: fab)
                if itemFrame.contains(point) == true {
                    return true
                }
            }
        }
        
        return false
    }
}
