//
//  KCFloatingActionButtonItem.swift
//  KCFloatingActionButton-Sample
//
//  Created by LeeSunhyoup on 2015. 10. 5..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

/**
    Floating Action Button Object's item.
*/
public class KCFloatingActionButtonItem: UIView {
    
    // MARK: - Properties
    
    /**
        This object's button size.
    */
    public var size: CGFloat = 42
    
    /**
        Button color.
    */
    public var buttonColor: UIColor = UIColor.whiteColor()
    
    /**
     Circle Shadow color.
     */
    public var circleShadowColor: UIColor = UIColor.blackColor()
    
    /**
     Title Shadow color.
     */
    public var titleShadowColor: UIColor = UIColor.blackColor()
    
    /**
        If you touch up inside button, it execute handler.
    */
    public var handler: ((KCFloatingActionButtonItem) -> Void)? = nil
    
    /**
        Shape layer of button.
    */
    private var circleLayer: CAShapeLayer = CAShapeLayer()
    
    /**
        If you keeping touch inside button, button overlaid with tint layer.
    */
    private var tintLayer: CAShapeLayer = CAShapeLayer()
    
    /**
        Item's title label.
    */
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
    
    /**
        Item's title.
    */
    public var title: String? = nil {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.frame.origin.x = -titleLabel.frame.size.width - 10
            titleLabel.frame.origin.y = self.frame.height/2-titleLabel.frame.size.height/2
        }
    }
    
    /**
        Item's icon image view.
    */
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
    
    /**
        Item's icon.
    */
    public var icon: UIImage? = nil {
        didSet {
            iconImageView.image = icon
        }
    }
    
    
    // MARK: - Initialize
    
    /**
        Initialize with default property.
    */
    public init() {
        super.init(frame: CGRectMake(0, 0, size, size))
        backgroundColor = UIColor.clearColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
        Set size, frame and draw layers.
    */
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
        circleLayer.shadowOffset = CGSizeMake(1, 1)
        circleLayer.shadowRadius = 2
        circleLayer.shadowColor = circleShadowColor.CGColor
        circleLayer.shadowOpacity = 0.4
        
        titleLabel.layer.shadowOffset = CGSizeMake(1, 1)
        titleLabel.layer.shadowRadius = 2
        titleLabel.layer.shadowColor = titleShadowColor.CGColor
        titleLabel.layer.shadowOpacity = 0.4
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

