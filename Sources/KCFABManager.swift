//
//  KCFABManager.swift
//  KCFloatingActionButton-Sample
//
//  Created by LeeSunhyoup on 2015. 10. 13..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

/**
    KCFloatingActionButton dependent on UIWindow.
*/
public class KCFABManager: NSObject {
    struct StaticInstance {
        static var dispatchToken: dispatch_once_t = 0
        static var instance: KCFABManager?
    }
    
    public class func defaultInstance() -> KCFABManager {
        dispatch_once(&StaticInstance.dispatchToken) {
            StaticInstance.instance = KCFABManager()
        }
        return StaticInstance.instance!
    }
    
    var _fabWindow: KCFABWindow? = nil
    var fabWindow: KCFABWindow {
        get {
            if _fabWindow == nil {
                _fabWindow = KCFABWindow(frame: UIScreen.mainScreen().bounds)
                _fabWindow?.rootViewController = fabController
            }
            return _fabWindow!
        }
    }
    
    var _fabController: KCFABViewController? = nil
    var fabController: KCFABViewController {
        get {
            if _fabController == nil {
                _fabController = KCFABViewController()
            }
            return _fabController!
        }
    }
    
    public func getButton() -> KCFloatingActionButton {
        return fabController.fab
    }
    
    public func show(animated: Bool = true) {
        if animated == true {
            fabWindow.hidden = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.fabWindow.alpha = 1
            })
        } else {
            fabWindow.hidden = false
        }
    }
    
    public func hide(animated: Bool = true) {
        if animated == true {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.fabWindow.alpha = 0
                }, completion: { finished in
                    self.fabWindow.hidden = true
            })
        } else {
            fabWindow.hidden = true
        }
    }
    
    public func toggle(animated: Bool = true) {
        if fabWindow.hidden == false {
            self.hide(animated)
        } else {
            self.show(animated)
        }
    }
    
    public func isHidden() -> Bool {
        return fabWindow.hidden
    }
}