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
class FloatyWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.windowLevel = UIWindow.Level.normal
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let floatyViewController = rootViewController as? FloatyViewController
        if let floaty = floatyViewController?.floaty {
            if floaty.closed == false {
                return true
            }
            
            if floaty.frame.contains(point) == true {
                return true
            }
            
            for item in floaty.items {
                let itemFrame = self.convert(item.frame, from: floaty)
                if itemFrame.contains(point) == true {
                    return true
                }
            }
        }
        
        return false
    }
}
