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
open class FloatyManager: NSObject {
    private static var __once: () = {
            StaticInstance.instance = FloatyManager()
        }()
    struct StaticInstance {
        static var dispatchToken: Int = 0
        static var instance: FloatyManager?
    }
    
    class func defaultInstance() -> FloatyManager {
        _ = FloatyManager.__once
        return StaticInstance.instance!
    }
    
    var _floatyWindow: FloatyWindow? = nil
    var floatyWindow: FloatyWindow {
        get {
            if _floatyWindow == nil {
                _floatyWindow = FloatyWindow(frame: UIScreen.main.bounds)
                _floatyWindow?.rootViewController = floatyController
            }
            return _floatyWindow!
        }
    }
    
    var _floatyController: FloatyViewController? = nil
    var floatyController: FloatyViewController {
        get {
            if _floatyController == nil {
                _floatyController = FloatyViewController()
            }
            return _floatyController!
        }
    }
    
    
    open var button: Floaty {
        get {
            return floatyController.floaty
        }
    }
    
    private let fontDescriptor: UIFontDescriptor
    private var _font: UIFont
    
    public override init() {
        fontDescriptor = UIFont.systemFont(ofSize: 20.0).fontDescriptor
        _font = UIFont(descriptor: fontDescriptor, size: 20)
    }
    
    open var font: UIFont {
        get {
            return _font
        }
        set {
            _font = newValue
        }
    }
    
    private var _rtlMode = false
    open var rtlMode: Bool {
        get {
            return _rtlMode
        }
        set{
            _rtlMode = newValue
        }
    }
    
    open func show(_ animated: Bool = true) {
        if animated == true {
            floatyWindow.isHidden = false
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.floatyWindow.alpha = 1
            })
        } else {
            floatyWindow.isHidden = false
        }
    }
    
    open func hide(_ animated: Bool = true) {
        if animated == true {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.floatyWindow.alpha = 0
                }, completion: { finished in
                    self.floatyWindow.isHidden = true
            })
        } else {
            floatyWindow.isHidden = true
        }
    }
    
    open func toggle(_ animated: Bool = true) {
        if floatyWindow.isHidden == false {
            self.hide(animated)
        } else {
            self.show(animated)
        }
    }
    
    open var hidden: Bool {
        get {
            return floatyWindow.isHidden
        }
    }
}
