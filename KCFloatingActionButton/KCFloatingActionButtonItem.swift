//
//  KCFloatingActionButtonItem.swift
//  KCFloatingActionButton-Sample
//
//  Created by LeeSunhyoup on 2015. 10. 5..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

public class KCFloatingActionButtonItem: UIView {
    public var size: CGFloat = 42
    public var buttonColor: UIColor = UIColor.whiteColor()
    public var handler: ((KCFloatingActionButtonItem) -> Void)? = nil
    
    private var circleLayer: CAShapeLayer = CAShapeLayer()
    private var tintLayer: CAShapeLayer = CAShapeLayer()
    
    var _titleLabel: UILabel? = nil
    public var titleLabel: UILabel {
        get {
            if _titleLabel == nil {
                _titleLabel = UILabel()
                _titleLabel?.textColor = UIColor.whiteColor()
                addSubview(_titleLabel!)
            }
            return _titleLabel!
        }
    }
    
    public var title: String? = nil {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.frame.origin.x = -titleLabel.frame.size.width - 10
            titleLabel.frame.origin.y = self.frame.height/2-titleLabel.frame.size.height/2
        }
    }
    
    var _iconImageView: UIImageView? = nil
    public var iconImageView: UIImageView {
        get {
            if _iconImageView == nil {
                _iconImageView = UIImageView(frame: CGRectMake(size/2-(size/2)/2, size/2-(size/2)/2, size/2, size/2))
                addSubview(_iconImageView!)
            }
            return _iconImageView!
        }
    }
    public var icon: UIImage? = nil {
        didSet {
            iconImageView.image = icon
        }
    }
    
    public init() {
        super.init(frame: CGRectMake(0, 0, size, size))
        backgroundColor = UIColor.clearColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
        createCircleLayer()
        setShadow()
        
        if _titleLabel != nil {
            bringSubviewToFront(_titleLabel!)
        }
        if _iconImageView != nil {
            bringSubviewToFront(_iconImageView!)
        }
    }
    
    private func createCircleLayer() {
        circleLayer.frame = CGRectMake(0, 0, size, size)
        circleLayer.backgroundColor = buttonColor.CGColor
        circleLayer.cornerRadius = size/2
        layer.addSublayer(circleLayer)
    }
    
    private func createTintLayer() {
        tintLayer.frame = CGRectMake(0, 0, size, size)
        tintLayer.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
        tintLayer.cornerRadius = size/2
        layer.addSublayer(tintLayer)
    }
    
    private func setShadow() {
        layer.shadowOffset = CGSizeMake(1, 1)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.4
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.locationInView(self) == nil { return }
                createTintLayer()
            }
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.locationInView(self) == nil { return }
                createTintLayer()
            }
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tintLayer.removeFromSuperlayer()
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.locationInView(self) == nil { return }
                handler?(self)
            }
        }
    }
}

