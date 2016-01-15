//
//  KCFloatingActionButton.swift
//
//  Created by LeeSunhyoup on 2015. 10. 4..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

/**
    Floating Action Button Object. It has `KCFloatingActionButtonItem` objects.
    KCFloatingActionButton support storyboard designable.
*/
@IBDesignable
public class KCFloatingActionButton: UIView {
    // MARK: - Properties
    
    /**
        `KCFloatingActionButtonItem` objects.
    */
    public var items: [KCFloatingActionButtonItem] = []
    
    /**
        This object's button size.
    */
    public var size: CGFloat = 56 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /**
        Padding from bottom right of UIScreen or superview.
    */
    public var paddingX: CGFloat = 14 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    public var paddingY: CGFloat = 14 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /**
        Button color.
    */
    @IBInspectable public var buttonColor: UIColor = UIColor(red: 73/255.0, green: 151/255.0, blue: 241/255.0, alpha: 1)
    
    /**
        Plus icon color inside button.
    */
    @IBInspectable public var plusColor: UIColor = UIColor(white: 0.2, alpha: 1)
    
    /**
        Background overlaying color.
    */
    @IBInspectable public var overlayColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    
    /**
        The space between the item and item.
    */
    @IBInspectable public var itemSpace: CGFloat = 14
    
    /**
        Child item's default size.
    */
    @IBInspectable public var itemSize: CGFloat = 42
    
    /**
        Child item's default button color.
    */
    @IBInspectable public var itemButtonColor: UIColor = UIColor.whiteColor()
    
    /**
        Child item's default shadow color.
    */
    @IBInspectable public var itemShadowColor: UIColor = UIColor.blackColor()
    
    /**
    
    */
    public var closed: Bool = true
    
    /**
        Button shape layer.
    */
    private var circleLayer: CAShapeLayer = CAShapeLayer()
    
    /**
        Plus icon shape layer.
    */
    private var plusLayer: CAShapeLayer = CAShapeLayer()
    
    /**
        If you keeping touch inside button, button overlaid with tint layer.
    */
    private var tintLayer: CAShapeLayer = CAShapeLayer()
    
    /**
        If you show items, background overlaid with overlayColor.
    */
    private var overlayLayer: CAShapeLayer = CAShapeLayer()
    
    /**
        If you created this object from storyboard or `initWithFrame`, this property set true.
    */
    private var isCustomFrame: Bool = false
    
    // MARK: - Initialize
    
    /**
        Initialize with default property.
    */
    public init() {
        super.init(frame: CGRectMake(0, 0, size, size))
        backgroundColor = UIColor.clearColor()
        setObserver()
    }
    
    /**
        Initialize with custom size.
    */
    public init(size: CGFloat) {
        self.size = size
        super.init(frame: CGRectMake(0, 0, size, size))
        backgroundColor = UIColor.clearColor()
        setObserver()
    }
    
    /**
        Initialize with custom frame.
    */
    public override init(frame: CGRect) {
        super.init(frame: frame)
        size = min(frame.size.width, frame.size.height)
        backgroundColor = UIColor.clearColor()
        isCustomFrame = true
        setObserver()
    }
    
    /**
        Initialize from storyboard.
    */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        size = min(frame.size.width, frame.size.height)
        backgroundColor = UIColor.clearColor()
        clipsToBounds = false
        isCustomFrame = true
        setObserver()
    }
    
    // MARK: - Method
    
    /**
        Set size and frame.
    */
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        if isCustomFrame == false {
            setRightBottomFrame()
        } else {
            size = min(frame.size.width, frame.size.height)
        }
    }
    
    /**
        Draw layers.
    */
    public override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        super.drawLayer(layer, inContext: ctx)
        setOverlayLayer()
        setCircleLayer()
        setPlusLayer()
        setShadow()
    }
    
    /**
        Items open.
    */
    public func open() {
        UIView.animateWithDuration(0.3, delay: 0,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 0.3,
            options: [.CurveEaseInOut], animations: { () -> Void in
                self.plusLayer.transform = CATransform3DMakeRotation(self.degreesToRadians(-45), 0.0, 0.0, 1.0)
                self.overlayLayer.opacity = 1
            }, completion: nil)
        
        var itemHeight: CGFloat = 0
        var delay = 0.0
        for item in items {
            if item.hidden == true { continue }
            itemHeight += item.size
            itemHeight += self.itemSpace
            item.frame.origin.y = -itemHeight
            item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
            UIView.animateWithDuration(0.3, delay: delay,
                usingSpringWithDamping: 0.55,
                initialSpringVelocity: 0.3,
                options: [.CurveEaseInOut], animations: { () -> Void in
                    item.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    item.alpha = 1
                }, completion: nil)
            
            delay += 0.1
        }
        closed = false
    }
    
    /**
        Items close.
    */
    public func close() {
        UIView.animateWithDuration(0.3, delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [], animations: { () -> Void in
                self.plusLayer.transform = CATransform3DMakeRotation(self.degreesToRadians(0), 0.0, 0.0, 1.0)
                self.overlayLayer.opacity = 0
            }, completion: nil)
        
        var delay = 0.0
        for item in items.reverse() {
            if item.hidden == true { continue }
            UIView.animateWithDuration(0.15, delay: delay, options: [], animations: { () -> Void in
                    item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
                    item.alpha = 0
                }, completion: nil)
            delay += 0.1
        }
        closed = true
    }
    
    /**
        Items open or close.
    */
    public func toggle() {
        if closed == true {
            open()
        } else {
            close()
        }
    }
    
    /**
        Add custom item
    */
    public func addItem(item item: KCFloatingActionButtonItem) {
        item.frame.origin = CGPointMake(size/2-item.size/2, size/2-item.size/2)
        item.alpha = 0
        items.append(item)
        addSubview(item)
    }
    
    /**
        Add item with title.
    */
    public func addItem(title title: String) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.title = title
        addItem(item: item)
        return item
    }
    
    /**
        Add item with title and icon.
    */
    public func addItem(title: String, icon: UIImage) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.title = title
        item.icon = icon
        addItem(item: item)
        return item
    }
    
    /**
        Add item with title, icon or handler.
    */
    public func addItem(title: String, icon: UIImage, handler: ((KCFloatingActionButtonItem) -> Void)) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.title = title
        item.icon = icon
        item.handler = handler
        addItem(item: item)
        return item
    }
    
    /**
        Add item with icon.
    */
    public func addItem(icon icon: UIImage) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.icon = icon
        addItem(item: item)
        return item
    }
    
    /**
        Add item with icon and handler.
    */
    public func addItem(icon: UIImage, handler: ((KCFloatingActionButtonItem) -> Void)) -> KCFloatingActionButtonItem {
        let item = KCFloatingActionButtonItem()
        itemDefaultSet(item)
        item.icon = icon
        item.handler = handler
        addItem(item: item)
        return item
    }
    
    /**
        Remove item.
    */
    public func removeItem(item item: KCFloatingActionButtonItem) {
        guard let index = items.indexOf(item) else { return }
        items[index].removeFromSuperview()
        items.removeAtIndex(index)
    }
    
    /**
        Remove item with index.
    */
    public func removeItem(index index: Int) {
        items[index].removeFromSuperview()
        items.removeAtIndex(index)
    }
    
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if closed == false {
            for item in items {
                if item.hidden == true { continue }
                let itemPoint = item.convertPoint(point, fromView: self)
                if CGRectContainsPoint(item.bounds, itemPoint) == true {
                    return item.hitTest(itemPoint, withEvent: event)
                }
            }
            
            let buttonPoint = self.convertPoint(point, fromView: self)
            if CGRectContainsPoint(self.bounds, buttonPoint) == false {
                close()
                return super.hitTest(point, withEvent: event)
            }
        }
        
        return super.hitTest(point, withEvent: event)
    }
    
    private func setCircleLayer() {
        circleLayer.removeFromSuperlayer()
        circleLayer.frame = CGRectMake(0, 0, size, size)
        circleLayer.backgroundColor = buttonColor.CGColor
        circleLayer.cornerRadius = size/2
        layer.addSublayer(circleLayer)
    }
    
    private func setPlusLayer() {
        plusLayer.removeFromSuperlayer()
        plusLayer.frame = CGRectMake(0, 0, size, size)
        plusLayer.lineCap = kCALineCapRound
        plusLayer.strokeColor = plusColor.CGColor
        plusLayer.lineWidth = 2.0
        plusLayer.path = plusBezierPath().CGPath
        layer.addSublayer(plusLayer)
    }
    
    private func setTintLayer() {
        tintLayer.frame = CGRectMake(0, 0, size, size)
        tintLayer.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2).CGColor
        tintLayer.cornerRadius = size/2
        layer.addSublayer(tintLayer)
    }
    
    private func setOverlayLayer() {
        overlayLayer.removeFromSuperlayer()
        overlayLayer.frame = CGRectMake(
            -UIScreen.mainScreen().bounds.width+(UIScreen.mainScreen().bounds.width-frame.origin.x),
            -UIScreen.mainScreen().bounds.height+(UIScreen.mainScreen().bounds.height-frame.origin.y),
            UIScreen.mainScreen().bounds.width,
            UIScreen.mainScreen().bounds.height
        )
        overlayLayer.backgroundColor = overlayColor.CGColor
        overlayLayer.opacity = 0
        overlayLayer.zPosition = -1
        layer.addSublayer(overlayLayer)
    }
    
    private func setShadow() {
        layer.shadowOffset = CGSizeMake(1, 1)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.4
    }
    
    private func plusBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(size/2, size/3))
        path.addLineToPoint(CGPointMake(size/2, size-size/3))
        path.moveToPoint(CGPointMake(size/3, size/2))
        path.addLineToPoint(CGPointMake(size-size/3, size/2))
        return path
    }
    
    private func itemDefaultSet(item: KCFloatingActionButtonItem) {
        item.buttonColor = itemButtonColor
        item.circleShadowColor = itemShadowColor
        item.titleShadowColor = itemShadowColor
        item.size = itemSize
    }
    
    private func setRightBottomFrame(keyboardSize: CGFloat = 0) {
        if superview == nil {
            frame = CGRectMake(
                UIScreen.mainScreen().bounds.size.width-size-paddingX,
                UIScreen.mainScreen().bounds.size.height-size-paddingY-keyboardSize,
                size,
                size
            )
        } else {
            frame = CGRectMake(
                superview!.bounds.size.width-size-paddingX,
                superview!.bounds.size.height-size-paddingY-keyboardSize,
                size,
                size
            )
        }
    }
    
    private func setObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.locationInView(self) == nil { return }
                setTintLayer()
            }
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.locationInView(self) == nil { return }
                setTintLayer()
            }
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        tintLayer.removeFromSuperlayer()
        if touches.count == 1 {
            let touch = touches.first
            if touch?.tapCount == 1 {
                if touch?.locationInView(self) == nil { return }
                toggle()
            }
        }
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (object as? UIView) == superview && keyPath == "frame" {
            if isCustomFrame == false {
                setRightBottomFrame()
                setOverlayLayer()
            } else {
                size = min(frame.size.width, frame.size.height)
            }
        }
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        superview?.removeObserver(self, forKeyPath: "frame")
        super.willMoveToSuperview(newSuperview)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        superview?.addObserver(self, forKeyPath: "frame", options: [], context: nil)
    }
    
    internal func deviceOrientationDidChange(notification: NSNotification) {
        var keyboardSize: CGFloat = 0.0
        if let size = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size {
            keyboardSize = size.height
        }
        
        if isCustomFrame == false {
            setRightBottomFrame(keyboardSize)
        } else {
            size = min(frame.size.width, frame.size.height)
        }
    }
    
    internal func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size else { return }
        
        if isCustomFrame == false {
            setRightBottomFrame(keyboardSize.height)
        } else {
            size = min(frame.size.width, frame.size.height)
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.frame = CGRectMake(
                UIScreen.mainScreen().bounds.width-self.size-self.paddingX,
                UIScreen.mainScreen().bounds.height-self.size-self.paddingY - keyboardSize.height,
                self.size,
                self.size
            )
            }, completion: nil)
    }
    
    internal func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            if self.isCustomFrame == false {
                self.setRightBottomFrame()
            } else {
                self.size = min(self.frame.size.width, self.frame.size.height)
            }
            
            }, completion: nil)
    }
}

extension KCFloatingActionButton {
    private func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees / 180.0 * CGFloat(M_PI)
    }
}
