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
open class KCFloatingActionButtonItem: UIView {

    // MARK: - Properties

    /**
     This object's button size.
     */
    open var size: CGFloat = 42 {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: size, height: size)
            titleLabel.frame.origin.y = self.frame.height/2-titleLabel.frame.size.height/2
            _iconImageView?.center = CGPoint(x: size/2, y: size/2) + imageOffset
            self.setNeedsDisplay()
        }
    }

    /**
     Button color.
     */
    open var buttonColor: UIColor = UIColor.white

    /**
     Title label color.
     */
    open var titleColor: UIColor = UIColor.white {
        didSet {
            titleLabel.textColor = titleColor
        }
    }

    /**
     Circle Shadow color.
     */
    open var circleShadowColor: UIColor = UIColor.black

    /**
     Title Shadow color.
     */
    open var titleShadowColor: UIColor = UIColor.black

    /**
     If you touch up inside button, it execute handler.
     */
    open var handler: ((KCFloatingActionButtonItem) -> Void)? = nil

    open var imageOffset: CGPoint = CGPoint.zero
    open var imageSize: CGSize = CGSize(width: 25, height: 25) {
        didSet {
            _iconImageView?.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        }
    }

    /**
     Reference to parent
     */
    open weak var actionButton: KCFloatingActionButton?

    /**
     Shape layer of button.
     */
    fileprivate var circleLayer: CAShapeLayer = CAShapeLayer()

    /**
     If you keeping touch inside button, button overlaid with tint layer.
     */
    fileprivate var tintLayer: CAShapeLayer = CAShapeLayer()

    /**
     Item's title label.
     */
    var _titleLabel: UILabel? = nil
    open var titleLabel: UILabel {
        get {
            if _titleLabel == nil {
                _titleLabel = UILabel()
                _titleLabel?.textColor = titleColor
                addSubview(_titleLabel!)
            }
            return _titleLabel!
        }
    }

    /**
     Item's title.
     */
    open var title: String? = nil {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.frame.origin.x = -titleLabel.frame.size.width - 10
            titleLabel.frame.origin.y = self.size/2-titleLabel.frame.size.height/2
        }
    }

    /**
     Item's icon image view.
     */
    var _iconImageView: UIImageView? = nil
    open var iconImageView: UIImageView {
        get {
            if _iconImageView == nil {
                _iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
                _iconImageView?.center = CGPoint(x: size/2, y: size/2) + imageOffset
                _iconImageView?.contentMode = UIViewContentMode.scaleAspectFill
                addSubview(_iconImageView!)
            }
            return _iconImageView!
        }
    }

    /**
     Item's icon.
     */
    open var icon: UIImage? = nil {
        didSet {
            iconImageView.image = icon
        }
    }

    /**
      itemBackgroundColor change
    */
    public var itemBackgroundColor: UIColor? = nil {
      didSet { circleLayer.backgroundColor = itemBackgroundColor?.cgColor }
    }

    // MARK: - Initialize

    /**
     Initialize with default property.
     */
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        backgroundColor = UIColor.clear
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     Set size, frame and draw layers.
     */
    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        createCircleLayer()
        setShadow()

        if _titleLabel != nil {
            bringSubview(toFront: _titleLabel!)
        }
        if _iconImageView != nil {
            bringSubview(toFront: _iconImageView!)
        }
    }

    fileprivate func createCircleLayer() {
        //        circleLayer.frame = CGRectMake(frame.size.width - size, 0, size, size)
        let castParent : KCFloatingActionButton = superview as! KCFloatingActionButton
        circleLayer.frame = CGRect(x: castParent.itemSize/2 - (size/2), y: 0, width: size, height: size)
        circleLayer.backgroundColor = buttonColor.cgColor
        circleLayer.cornerRadius = size/2
        layer.addSublayer(circleLayer)
    }

    fileprivate func createTintLayer() {
        //        tintLayer.frame = CGRectMake(frame.size.width - size, 0, size, size)
        let castParent : KCFloatingActionButton = superview as! KCFloatingActionButton
        tintLayer.frame = CGRect(x: castParent.itemSize/2 - (size/2), y: 0, width: size, height: size)
        tintLayer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        tintLayer.cornerRadius = size/2
        layer.addSublayer(tintLayer)
    }

    fileprivate func setShadow() {
        circleLayer.shadowOffset = CGSize(width: 1, height: 1)
        circleLayer.shadowRadius = 2
        circleLayer.shadowColor = circleShadowColor.cgColor
        circleLayer.shadowOpacity = 0.4

        titleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel.layer.shadowRadius = 2
        titleLabel.layer.shadowColor = titleShadowColor.cgColor
        titleLabel.layer.shadowOpacity = 0.4
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.location(in: self) == nil { return }
                createTintLayer()
            }
        }
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.location(in: self) == nil { return }
                createTintLayer()
            }
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tintLayer.removeFromSuperlayer()
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.location(in: self) == nil { return }
                if actionButton != nil && actionButton!.autoCloseOnTap {
                    actionButton!.close()
                }
                handler?(self)
            }
        }
    }
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
