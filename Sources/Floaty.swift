//
//  Floaty.swift
//
//  Created by LeeSunhyoup on 2015. 10. 4..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

@objc public enum FloatyOpenAnimationType: Int {
  case pop
  case fade
  case slideLeft
  case slideUp
  case slideDown
  case none
}

@objc public enum FloatyVerticalDirection: Int {
  case up
  case down
}

/**
 Floaty Object. It has `FloatyItem` objects.
 Floaty support storyboard designable.
 */
@IBDesignable
open class Floaty: UIView {
  // MARK: - Properties
  
  /**
   `FloatyItem` objects.
   */
  @objc open var items: [FloatyItem] = []
  
  /**
   This object's button size.
   */
  @objc open var size: CGFloat = 56 {
    didSet {
      self.setNeedsDisplay()
      self.recalculateItemsOrigin()
    }
  }
  
  /**
   Padding from bottom right of UIScreen or superview.
   */
  @objc open var paddingX: CGFloat = 14 {
    didSet {
      self.setNeedsDisplay()
    }
  }
  @objc open var paddingY: CGFloat = 14 {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  /**
   Automatically closes child items when tapped
   */
  @IBInspectable
  @objc open var autoCloseOnTap: Bool = true

  /**
   Runs first item handler directly on tap (without opening menu)
   */
  @IBInspectable
  @objc open var handleFirstItemDirectly: Bool = false
    
  /**
   Places button relative to the Safe Area
   */
  @IBInspectable
  @objc open var relativeToSafeArea: Bool = true
  
  /**
   Degrees to rotate image
   */
  @objc @IBInspectable
  open var rotationDegrees: CGFloat = -45
  
  /**
   Animation speed of buttons
   */
  @objc @IBInspectable
  open var animationSpeed: Double = 0.1
  
  /**
   Button color.
   */
  @objc @IBInspectable
  open var buttonColor: UIColor = UIColor(red: 73/255.0, green: 151/255.0, blue: 241/255.0, alpha: 1)
  
  /**
   Button shadow color.
   */
  @objc @IBInspectable
  open var buttonShadowColor: UIColor = UIColor.black
  
  /**
   Button image.
   */
  @objc @IBInspectable
  open var buttonImage: UIImage? = nil {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  /**
   Plus icon color inside button.
   */
  @objc @IBInspectable
  open var plusColor: UIColor = UIColor(white: 0.2, alpha: 1)
  
  /**
   Background overlaying color.
   */
  @objc @IBInspectable
  open var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.3)
  
  /**
   The space between the item and item.
   */
  @objc @IBInspectable
  open var itemSpace: CGFloat = 14
  
  /**
   Child item's default size.
   */
  @objc @IBInspectable
  open var itemSize: CGFloat = 42 {
    didSet {
      self.items.forEach { item in
        item.size = self.itemSize
      }
      self.recalculateItemsOrigin()
      self.setNeedsDisplay()
    }
  }
  
  /**
   Child item's default button color.
   */
  @objc @IBInspectable
  open var itemButtonColor: UIColor = UIColor.white
  
  /**
   Child item's default title label color.
   */
  @objc @IBInspectable
  open var itemTitleColor: UIColor = UIColor.white
  
  /**
   Child item's image color
   */
  @objc @IBInspectable
  open var itemImageColor: UIColor? = nil
  
  /**
   Enable/disable shadow.
   */
  @objc @IBInspectable
  open var hasShadow: Bool = true
  
  /**
   Child item's default shadow color.
   */
  @objc @IBInspectable
  open var itemShadowColor: UIColor = UIColor.black
  
  /**
   
   */
  @objc open var closed: Bool = true {
    didSet {
      accessibilityViewIsModal = !closed
    }
  }

  /**
   Make the menu button draggable
   */
  @objc open var isDraggable: Bool = false {
    didSet {
      if isDraggable {
        self.addDragging()
      }
    }
  }

  /**
   Whether or not floaty responds to keyboard notifications and adjusts its position accordingly
   */
  @objc @IBInspectable
  open var respondsToKeyboard: Bool = true
  
  @objc open var openAnimationType: FloatyOpenAnimationType = .pop
  
  @objc open var verticalDirection: FloatyVerticalDirection = .up
  
  @objc open var friendlyTap: Bool = true
  
  @objc open var sticky: Bool = false
    
  public static var global: FloatyManager {
    get {
      return FloatyManager.defaultInstance()
    }
  }
  
  /**
   Delegate that can be used to learn more about the behavior of the FAB widget.
   */
  @IBOutlet open weak var fabDelegate: FloatyDelegate?
  
  /**
   Button selected color.
  */
  @IBInspectable open var selectedColor: UIColor? = nil {
    didSet {
        self.setNeedsDisplay()
    }
  }
    
  /**
   Button shape layer.
   */
  fileprivate var circleLayer: CAShapeLayer = CAShapeLayer()
  
  /**
   Plus icon shape layer.
   */
  fileprivate var plusLayer: CAShapeLayer = CAShapeLayer()
  
  /**
   Button image view.
   */
  fileprivate var buttonImageView: UIImageView = UIImageView()
  
  /**
   If you keeping touch inside button, button overlaid with tint layer.
   */
  fileprivate var tintLayer: CAShapeLayer = CAShapeLayer()
  
  /**
   If you show items, background overlaid with overlayColor.
   */
  //    private var overlayLayer: CAShapeLayer = CAShapeLayer()
  
  fileprivate var overlayView : UIControl = UIControl()
  
  /**
   Keep track of whether overlay open animation completes, to avoid animation conflicts.
   */
  fileprivate var overlayViewDidCompleteOpenAnimation: Bool = true
  
  /**
   If you created this object from storyboard or `initWithFrame`, this property set true.
   */
  fileprivate var isCustomFrame: Bool = false
  
  /**
   An accessibility button for the main Fab Button
   */
  fileprivate var accessibilityView : UIView = UIView()
  
  // MARK: - Initialize
  
  /**
   Initialize with default property.
   */
  public init() {
    super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    backgroundColor = UIColor.clear
    setObserver()
    setAccessibilityView()
  }
  
  /**
   Initialize with custom size.
   */
  public init(size: CGFloat) {
    self.size = size
    super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    backgroundColor = UIColor.clear
    setObserver()
    setAccessibilityView()
  }
  
  /**
   Initialize with custom frame.
   */
  public override init(frame: CGRect) {
    super.init(frame: frame)
    size = min(frame.size.width, frame.size.height)
    backgroundColor = UIColor.clear
    isCustomFrame = true
    setObserver()
    setAccessibilityView()
  }
  
  /**
   Initialize from storyboard.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    size = min(frame.size.width, frame.size.height)
    backgroundColor = UIColor.clear
    clipsToBounds = false
    isCustomFrame = true
    setObserver()
    setAccessibilityView()
  }
  
  // MARK: - Method
  
  /**
   Set size and frame.
   */
  open override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    if isCustomFrame == false {
      setBottomFrameAccordingToRTL()
    } else {
      size = min(frame.size.width, frame.size.height)
    }
    
    setCircleLayer()
    if buttonImage == nil {
      setPlusLayer()
    } else {
      setButtonImage()
    }
    setShadow()
  }
  
  /**
   Items open.
   */
  @objc open func open() {
    if handleFirstItemDirectly, let item = items.first, let handler = item.handler {
      handler(item)
      return
    }

    if let shouldOpen = fabDelegate?.floatyShouldOpen?(self), shouldOpen == false {
      return
    }

    fabDelegate?.floatyWillOpen?(self)
    let animationGroup = DispatchGroup()
    
    if(items.count > 0){
      
      setOverlayView()
      self.superview?.insertSubview(overlayView, aboveSubview: self)
      self.superview?.bringSubviewToFront(self)
      overlayView.addTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
      
      overlayViewDidCompleteOpenAnimation = false
      animationGroup.enter()
      UIView.animate(withDuration: 0.3, delay: 0,
                     usingSpringWithDamping: 0.55,
                     initialSpringVelocity: 0.3,
                     options: UIView.AnimationOptions(), animations: { () -> Void in
                      self.plusLayer.transform = CATransform3DMakeRotation(self.degreesToRadians(self.rotationDegrees), 0.0, 0.0, 1.0)
                      self.buttonImageView.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(self.rotationDegrees))
                      self.overlayView.alpha = 1
      }, completion: {(f) -> Void in
        self.overlayViewDidCompleteOpenAnimation = true
        animationGroup.leave()
      })
      
      switch openAnimationType {
      case .pop:
        popAnimationWithOpen(group: animationGroup)
      case .fade:
        fadeAnimationWithOpen(group: animationGroup)
      case .slideLeft:
        slideLeftAnimationWithOpen(group: animationGroup)
      case .slideUp:
        slideUpAnimationWithOpen(group: animationGroup)
      case .slideDown:
        slideDownAnimationWithOpen(group: animationGroup)
      case .none:
        noneAnimationWithOpen()
      }
      
      UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: items.first);
    }
    
    animationGroup.notify(queue: .main) {
      self.fabDelegate?.floatyDidOpen?(self)
    }
    
    circleLayer.backgroundColor = self.selectedColor != nil ? self.selectedColor?.cgColor : self.buttonColor.cgColor
    
    fabDelegate?.floatyOpened?(self)
    closed = false
  }
  
  /**
   Items close.
   */
  @objc open func close() {
    if let shouldClose = fabDelegate?.floatyShouldClose?(self), shouldClose == false {
      return
    }

    fabDelegate?.floatyWillClose?(self)
    let animationGroup = DispatchGroup()
    
    if(items.count > 0){
      self.overlayView.removeTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
      animationGroup.enter()
      UIView.animate(withDuration: 0.3, delay: 0,
                     usingSpringWithDamping: 0.6,
                     initialSpringVelocity: 0.8,
                     options: [], animations: { () -> Void in
                      self.plusLayer.transform = CATransform3DMakeRotation(self.degreesToRadians(0), 0.0, 0.0, 1.0)
                      self.buttonImageView.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(0))
                      self.overlayView.alpha = 0
      }, completion: {(f) -> Void in
        if self.overlayViewDidCompleteOpenAnimation {
          self.overlayView.removeFromSuperview()
        }
        animationGroup.leave()
      })
      
      
      switch openAnimationType {
      case .pop:
        popAnimationWithClose(group: animationGroup)
      case .fade:
        fadeAnimationWithClose(group: animationGroup)
      case .slideLeft:
        slideLeftAnimationWithClose(group: animationGroup)
      case .slideUp:
        slideUpAnimationWithClose(group: animationGroup)
      case .slideDown:
        slideDownAnimationWithClose(group: animationGroup)
      case .none:
        noneAnimationWithClose()
      }
      UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: self);
    }
    
    animationGroup.notify(queue: .main) {
      self.fabDelegate?.floatyDidClose?(self)
    }
    
    circleLayer.backgroundColor = self.buttonColor.cgColor
    
    fabDelegate?.floatyClosed?(self)
    closed = true
  }
  
  /**
   Items open or close.
   */
  @objc open func toggle() {
    if items.count > 0 {
      if closed == true {
        open()
      } else {
        close()
      }
    } else {
      fabDelegate?.emptyFloatySelected?(self)
    }
  }
  
  /**
   Add custom item
   */
  @objc open func addItem(item: FloatyItem) {
    let big = size > item.size ? size : item.size
    let small = size <= item.size ? size : item.size
    item.frame.origin = CGPoint(x: big/2-small/2, y: big/2-small/2)
    item.alpha = 0
    item.actionButton = self
    items.append(item)
    addSubview(item)
  }
  
  
  /**
   Add item with title, titlePositon.
   titlePosition's default value is left.
   */
  @discardableResult
  @objc open func addItem(title: String, titlePosition: FloatyItemLabelPositionType = .left) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.titleLabelPosition = titlePosition
    item.title = title
    addItem(item: item)
    return item
  }
  
  /**
   Add item with title.
   */
  @discardableResult
  @objc open func addItem(title: String) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.title = title
    addItem(item: item)
    return item
  }
  
  /**
   Add item with title, titlePosition and icon.
   titlePosition's default value is left.
   */
  @discardableResult
  @objc open func addItem(_ title: String, icon: UIImage?, titlePosition: FloatyItemLabelPositionType = .left) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.titleLabelPosition = titlePosition
    item.title = title
    item.icon = icon
    addItem(item: item)
    return item
  }
  
  /**
   Add item with title and icon.
   */
  @discardableResult
  @objc open func addItem(_ title: String, icon: UIImage?) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.title = title
    item.icon = icon
    addItem(item: item)
    return item
  }
  
  /**
   Add item with title and handler.
   */
  @discardableResult
  @objc open func addItem(title: String, handler: @escaping ((FloatyItem) -> Void)) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.title = title
    item.handler = handler
    addItem(item: item)
    return item
  }
  
  /**
   Add item with titlePosition and handler.
   titlePosition's default value is left.
   */
  @discardableResult
  @objc open func addItem(title: String, titlePosition: FloatyItemLabelPositionType = .left, handler: @escaping ((FloatyItem) -> Void)) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.titleLabelPosition = titlePosition
    item.title = title
    item.handler = handler
    addItem(item: item)
    return item
  }
  
  /**
   Add item with title, icon or handler.
   */
  @discardableResult
  @objc open func addItem(_ title: String, icon: UIImage?, handler: @escaping ((FloatyItem) -> Void)) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.title = title
    item.icon = icon
    item.handler = handler
    addItem(item: item)
    return item
  }
  
  /**
   Add item with title, icon, titlePosition or handler.
   titlePosition's default value is left
   */
  @discardableResult
  @objc open func addItem(_ title: String, icon: UIImage?, titlePosition: FloatyItemLabelPositionType = .left, handler: @escaping ((FloatyItem) -> Void)) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.titleLabelPosition = titlePosition
    item.title = title
    item.icon = icon
    item.handler = handler
    addItem(item: item)
    return item
  }
  
  /**
   Add item with icon.
   */
  @discardableResult
  @objc open func addItem(icon: UIImage?) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.icon = icon
    addItem(item: item)
    return item
  }
  
  /**
   Add item with icon and handler.
   */
  @discardableResult
  @objc open func addItem(icon: UIImage?, handler: @escaping ((FloatyItem) -> Void)) -> FloatyItem {
    let item = FloatyItem()
    itemDefaultSet(item)
    item.icon = icon
    item.handler = handler
    addItem(item: item)
    return item
  }
  
  /**
   Remove item.
   */
  @objc open func removeItem(item: FloatyItem) {
    guard let index = items.firstIndex(of: item) else { return }
    items[index].removeFromSuperview()
    items.remove(at: index)
  }
  
  /**
   Remove item with index.
   */
  @objc open func removeItem(index: Int) {
    items[index].removeFromSuperview()
    items.remove(at: index)
  }
  
  @objc open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if closed == false {
      for item in items {
        if item.isHidden == true { continue }
        var itemPoint = item.convert(point, from: self)
        
        let tapArea = determineTapArea(item: item)
        if tapArea.contains(itemPoint) == true {
          itemPoint = item.bounds.origin
          return item.hitTest(itemPoint, with: event)
        }
      }
    }
    
    return super.hitTest(point, with: event)
  }
  
  fileprivate func determineTapArea(item : FloatyItem) -> CGRect {
    let tappableMargin : CGFloat = 30.0
    var x : CGFloat?
    if(item.titleLabelPosition == .left) {
      x = item.titleLabel.frame.origin.x + item.bounds.origin.x
    } else {
      x = item.bounds.origin.x
    }
    let y = item.bounds.origin.y
    
    var width: CGFloat
    if isCustomFrame {
      width = item.titleLabel.bounds.size.width + item.bounds.size.width + tappableMargin + paddingX
    } else {
      width = item.titleLabel.bounds.size.width + item.bounds.size.width + tappableMargin
    }
    let height = item.bounds.size.height
    
    return CGRect(x: x!, y: y, width: width, height: height)
  }
  
  fileprivate func setCircleLayer() {
    circleLayer.removeFromSuperlayer()
    circleLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
    circleLayer.backgroundColor = buttonColor.cgColor
    circleLayer.cornerRadius = size/2
    layer.addSublayer(circleLayer)
  }
  
  fileprivate func setPlusLayer() {
    plusLayer.removeFromSuperlayer()
    plusLayer.frame = CGRect(x: 0, y: 0, width: size, height: size)
    plusLayer.lineCap = CAShapeLayerLineCap.round
    plusLayer.strokeColor = plusColor.cgColor
    plusLayer.lineWidth = 2.0
    plusLayer.path = plusBezierPath().cgPath
    layer.addSublayer(plusLayer)
  }
  
  fileprivate func setButtonImage() {
    buttonImageView.removeFromSuperview()
    buttonImageView = UIImageView(image: buttonImage)
    buttonImageView.tintColor = plusColor
    buttonImageView.frame = CGRect(
      x: circleLayer.frame.origin.x + (size / 2 - buttonImageView.frame.size.width / 2),
      y: circleLayer.frame.origin.y + (size / 2 - buttonImageView.frame.size.height / 2),
      width: buttonImageView.frame.size.width,
      height: buttonImageView.frame.size.height
    )
    
    addSubview(buttonImageView)
  }
  
  fileprivate func setTintLayer() {
    tintLayer.frame = CGRect(x: circleLayer.frame.origin.x, y: circleLayer.frame.origin.y, width: size, height: size)
    tintLayer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
    tintLayer.cornerRadius = size/2
    layer.addSublayer(tintLayer)
  }
  
  fileprivate func setOverlayView() {
    setOverlayFrame()
    overlayView.backgroundColor = overlayColor
    overlayView.alpha = 0
    overlayView.isUserInteractionEnabled = true
    
  }
  fileprivate func setOverlayFrame() {
    if let superview = superview {
      overlayView.frame = CGRect(
        x: 0,y: 0,
        width: superview.bounds.width,
        height: superview.bounds.height
      )
    }
  }
  
  fileprivate func setShadow() {
    if !hasShadow {
      return
    }
    
    circleLayer.shadowOffset = CGSize(width: 1, height: 1)
    circleLayer.shadowRadius = 2
    circleLayer.shadowColor = buttonShadowColor.cgColor
    circleLayer.shadowOpacity = 0.4
  }
  
  fileprivate func plusBezierPath() -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: size/2, y: size/3))
    path.addLine(to: CGPoint(x: size/2, y: size-size/3))
    path.move(to: CGPoint(x: size/3, y: size/2))
    path.addLine(to: CGPoint(x: size-size/3, y: size/2))
    return path
  }
  
  fileprivate func itemDefaultSet(_ item: FloatyItem) {
    item.buttonColor = itemButtonColor
    
    /// Use separate color (if specified) for item button image, or default to the plusColor
    item.iconImageView.tintColor = itemImageColor ?? plusColor
    item.titleColor = itemTitleColor
    item.circleShadowColor = itemShadowColor
    item.titleShadowColor = itemShadowColor
    item.size = itemSize
  }
  
  
  fileprivate func setBottomFrameAccordingToRTL(_ keyboardSize: CGFloat = 0) {
    
    if FloatyManager.defaultInstance().rtlMode {
      setLeftBottomFrame(keyboardSize)
      self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
    }else {
      setRightBottomFrame(keyboardSize)
      self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
    }
  }
  
  fileprivate func setLeftBottomFrame(_ keyboardSize: CGFloat = 0) {
    if superview == nil {
      frame = CGRect(
        x: 0,
        y: (UIScreen.main.bounds.size.height - size - keyboardSize) - paddingY,
        width: size,
        height: size
      )
    } else {
      frame = CGRect(
        x: 0,
        y: (superview!.bounds.size.height-size-keyboardSize) - paddingY,
        width: size,
        height: size
      )
    }
    
    if friendlyTap == true {
      frame.size.width += paddingX
      frame.size.height += paddingY
    }
  }
  
  
  fileprivate func setRightBottomFrame(_ keyboardSize: CGFloat = 0) {
    
    var horizontalMargin = size;
    var verticalMargin = size + keyboardSize;
    
    if #available(iOS 11, *), relativeToSafeArea, let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets {
      horizontalMargin += safeAreaInsets.right
      verticalMargin += safeAreaInsets.bottom
    }
    
    if superview == nil {
      frame = CGRect(
        x: (UIScreen.main.bounds.size.width - horizontalMargin) - paddingX,
        y: (UIScreen.main.bounds.size.height - verticalMargin) - paddingY,
        width: size,
        height: size
      )
    } else {
      frame = CGRect(
        x: (superview!.bounds.size.width - horizontalMargin) - paddingX,
        y: (superview!.bounds.size.height - verticalMargin) - paddingY,
        width: size,
        height: size
      )
    }
    
    if friendlyTap == true {
      frame.size.width += paddingX
      frame.size.height += paddingY
    }
  }
  
  fileprivate func recalculateItemsOrigin() {
    for item in items {
      let big = size > item.size ? size : item.size
      let small = size <= item.size ? size : item.size
      item.frame.origin = CGPoint(x: big/2-small/2, y: big/2-small/2)
    }
  }
  
  fileprivate func setObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    if isTouched(touches) {
      setTintLayer()
    }
  }
  
  @objc open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    tintLayer.removeFromSuperlayer()
    if isTouched(touches) {
      toggle()
    }
  }
  
  fileprivate func isTouched(_ touches: Set<UITouch>) -> Bool {
    return touches.count == 1 && touches.first?.tapCount == 1 && touches.first?.location(in: self) != nil
  }
  
  open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if (object as? UIView) == superview && (keyPath == "frame" || keyPath == "bounds") {
      if isCustomFrame == false {
        setBottomFrameAccordingToRTL()
        setOverlayFrame()
      } else {
        size = min(frame.size.width, frame.size.height)
      }
    } else if (object as? UIScrollView) == superview && keyPath == "contentOffset" {
      let scrollView = object as! UIScrollView
    
        var horizontalMargin = size;
        var verticalMargin = size;
        if #available(iOS 11, *) {
            horizontalMargin += safeAreaInsets.right
            verticalMargin += safeAreaInsets.bottom
        }
        
      frame.origin.x = ((self.superview!.bounds.size.width - horizontalMargin) - paddingX) + scrollView.contentOffset.x
      frame.origin.y = ((self.superview!.bounds.size.height - verticalMargin) - paddingY) + scrollView.contentOffset.y
    }
  }
  
  open override func willMove(toSuperview newSuperview: UIView?) {
    superview?.removeObserver(self, forKeyPath: "frame")
    superview?.removeObserver(self, forKeyPath: "bounds")
    if sticky == true {
      if let superviews = self.getAllSuperviews() {
        for superview in superviews {
          if superview is UIScrollView {
            superview.removeObserver(self, forKeyPath: "contentOffset", context:nil)
          }
        }
      }
    }
    super.willMove(toSuperview: newSuperview)
  }
  
  open override func didMoveToSuperview() {
    super.didMoveToSuperview()
    superview?.addObserver(self, forKeyPath: "frame", options: [], context: nil)
    superview?.addObserver(self, forKeyPath: "bounds", options: [], context: nil)
    if sticky == true {
      if let superviews = self.getAllSuperviews() {
        for superview in superviews {
          if superview is UIScrollView {
            superview.addObserver(self, forKeyPath: "contentOffset", options: .new, context:nil)
          }
        }
      }
    }
  }
  
  @objc internal func deviceOrientationDidChange(_ notification: Notification) {
    guard let keyboardSize: CGFloat = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height else {
      return
    }
    
    /// Update overlay frame for new orientation dimensions
    setOverlayFrame()
    
    if isCustomFrame == false {
      setBottomFrameAccordingToRTL(keyboardSize)
    } else {
      size = min(frame.size.width, frame.size.height)
    }
  }
  
  @objc internal func keyboardWillShow(_ notification: Notification) {
    guard let keyboardSize: CGFloat = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height,
      respondsToKeyboard, !sticky else {
        return
    }
    
    if isCustomFrame == false {
      setBottomFrameAccordingToRTL(keyboardSize)
    } else {
      size = min(frame.size.width, frame.size.height)
    }
    
    UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
      self.frame = CGRect(
        x: UIScreen.main.bounds.width-self.size - self.paddingX,
        y: UIScreen.main.bounds.height-self.size - keyboardSize - self.paddingY,
        width: self.size,
        height: self.size
      )
    }, completion: nil)
  }
  
  @objc internal func keyboardWillHide(_ notification: Notification) {
    guard respondsToKeyboard, !sticky else {
      return
    }
    
    UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
      if self.isCustomFrame == false {
        self.setBottomFrameAccordingToRTL()
      } else {
        self.size = min(self.frame.size.width, self.frame.size.height)
      }
      
    }, completion: nil)
  }
}

/**
 Opening animation functions
 */
extension Floaty {
  /**
   Pop animation
   */
  fileprivate func popAnimationWithOpen(group: DispatchGroup) {
    var itemHeight: CGFloat = 0
    var delay = 0.0
    for item in items {
      if item.isHidden == true { continue }
      itemHeight += item.size + itemSpace
      item.layer.transform = CATransform3DIdentity
      let big = size > item.size ? size : item.size
      let small = size <= item.size ? size : item.size
      item.frame.origin.x = big/2-small/2
      if verticalDirection == .up {
        item.frame.origin.y = -itemHeight
      } else {
        item.frame.origin.y = itemHeight
      }
      item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
      group.enter()
      UIView.animate(withDuration: 0.3, delay: delay,
                     usingSpringWithDamping: 0.55,
                     initialSpringVelocity: 0.3,
                     options: UIView.AnimationOptions(), animations: { () -> Void in
                      item.layer.transform = CATransform3DIdentity
                      item.alpha = 1
      }, completion: { _ in
        group.leave()
      })
      
      delay += animationSpeed
    }
  }
  
  fileprivate func popAnimationWithClose(group: DispatchGroup) {
    var delay = 0.0
    for item in items.reversed() {
      if item.isHidden == true { continue }
      group.enter()
      UIView.animate(withDuration: 0.15, delay: delay, options: [], animations: { () -> Void in
        item.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
        item.alpha = 0
      }, completion: { _ in
        group.leave()
      })
      delay += animationSpeed
    }
  }
  
  /**
   Fade animation
   */
  fileprivate func fadeAnimationWithOpen(group: DispatchGroup) {
    var itemHeight: CGFloat = 0
    var delay = 0.0
    for item in items {
      if item.isHidden == true { continue }
      itemHeight += item.size + itemSpace
      if verticalDirection == .up {
        item.frame.origin.y = -itemHeight
      } else {
        item.frame.origin.y = itemHeight
      }
      group.enter()
      UIView.animate(withDuration: 0.4,
                     delay: delay,
                     options: [],
                     animations: { () -> Void in
                      item.alpha = 1
      }, completion: { _ in
        group.leave()
      })
      
      delay += animationSpeed * 2
    }
  }
  
  fileprivate func fadeAnimationWithClose(group: DispatchGroup) {
    var delay = 0.0
    for item in items.reversed() {
      if item.isHidden == true { continue }
      group.enter()
      UIView.animate(withDuration: 0.4,
                     delay: delay,
                     options: [],
                     animations: { () -> Void in
                      item.alpha = 0
      }, completion: { _ in
        group.leave()
      })
      delay += animationSpeed * 2
    }
  }
  
  /**
   Slide left animation
   */
  fileprivate func slideLeftAnimationWithOpen(group: DispatchGroup) {
    var itemHeight: CGFloat = 0
    var delay = 0.0
    for item in items {
      if item.isHidden == true { continue }
      itemHeight += item.size + itemSpace
      item.frame.origin.x = UIScreen.main.bounds.size.width - frame.origin.x
      if verticalDirection == .up {
        item.frame.origin.y = -itemHeight
      } else {
        item.frame.origin.y = itemHeight
      }
      group.enter()
      UIView.animate(withDuration: 0.3, delay: delay,
                     usingSpringWithDamping: 0.55,
                     initialSpringVelocity: 0.3,
                     options: UIView.AnimationOptions(), animations: { () -> Void in
                      item.frame.origin.x = self.size/2 - self.itemSize/2
                      item.alpha = 1
      }, completion: { _ in
        group.leave()
      })
      
      delay += animationSpeed
    }
  }
  
  fileprivate func slideLeftAnimationWithClose(group: DispatchGroup) {
    var delay = 0.0
    for item in items.reversed() {
      if item.isHidden == true { continue }
      group.enter()
      UIView.animate(withDuration: 0.3, delay: delay, options: [], animations: { () -> Void in
        item.frame.origin.x = UIScreen.main.bounds.size.width - self.frame.origin.x
        item.alpha = 0
      }, completion: { _ in
        group.leave()
      })
      delay += animationSpeed
    }
  }
  
  /**
   Slide up animation
   */
  fileprivate func slideUpAnimationWithOpen(group: DispatchGroup) {
    var itemHeight: CGFloat = 0
    for item in items {
      if item.isHidden == true { continue }
      if verticalDirection == .up {
        itemHeight += item.size + itemSpace
      } else {
        itemHeight -= item.size + itemSpace
      }
      group.enter()
      UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { () -> Void in
        item.frame.origin.y = -itemHeight
        item.alpha = 1
      }, completion: { _ in
        group.leave()
      })
    }
  }
  
  fileprivate func slideUpAnimationWithClose(group: DispatchGroup) {
    for item in items.reversed() {
      if item.isHidden == true { continue }
      group.enter()
      UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { () -> Void in
        item.frame.origin.y = 0
        item.alpha = 0
      }, completion: { _ in
        group.leave()
      })
    }
  }
  
  /**
   Slide down animation
   */
  fileprivate func slideDownAnimationWithOpen(group: DispatchGroup) {
    var itemHeight: CGFloat = 0
    
    if self.size > self.itemSize && verticalDirection == .down {
      itemHeight = self.size - self.itemSize
    }
    
    for item in items {
      if item.isHidden == true { continue }
      if verticalDirection == .up {
        itemHeight -= item.size + itemSpace
      } else {
        itemHeight += item.size + itemSpace
      }
      group.enter()
      UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { () -> Void in
        item.frame.origin.y = itemHeight
        item.alpha = 1
      }, completion: { _ in
        group.leave()
      })
    }
  }
  
  fileprivate func slideDownAnimationWithClose(group: DispatchGroup) {
    for item in items.reversed() {
      if item.isHidden == true { continue }
      group.enter()
      UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { () -> Void in
        item.frame.origin.y = 0
        item.alpha = 0
      }, completion: { _ in
        group.leave()
      })
    }
  }
  
  /**
   None animation
   */
  fileprivate func noneAnimationWithOpen() {
    var itemHeight: CGFloat = 0
    for item in items {
      if item.isHidden == true { continue }
      if verticalDirection == .up {
        itemHeight += item.size + itemSpace
      } else {
        itemHeight -= item.size + itemSpace
      }
      item.frame.origin.y = -itemHeight
      item.alpha = 1
    }
  }
  
  fileprivate func noneAnimationWithClose() {
    for item in items.reversed() {
      if item.isHidden == true { continue }
      item.frame.origin.y = 0
      item.alpha = 0
    }
  }
}

/**
 Util functions
 */
extension Floaty {
  fileprivate func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
    return degrees / 180.0 * CGFloat.pi
  }
}

extension UIView {
  fileprivate func getAllSuperviews() -> [UIView]? {
    if (self.superview == nil) {
      return nil
    }
    
    var superviews: [UIView] = []
    
    superviews.append(self.superview!)
    if let allSuperviews = self.superview!.getAllSuperviews() {
      superviews.append(contentsOf: allSuperviews)
    }
    
    return superviews
  }
}


// MARK: - Accessibility Handling
extension Floaty {
  open override func layoutSubviews() {
    super.layoutSubviews();
    accessibilityView.frame = CGRect(x: 0, y: 0, width: size, height: size)
  }
  
  func setAccessibilityView() {
    self.addSubview(accessibilityView)
    accessibilityView.isAccessibilityElement = true
    accessibilityView.accessibilityTraits.insert(.button)
  }
  
  open override var accessibilityLabel : String? {
    get {
      return accessibilityView.accessibilityLabel
    }
    set(newLabel) {
      accessibilityView.accessibilityLabel = newLabel
    }
  }
  
  open override var accessibilityHint : String? {
    get {
      return accessibilityView.accessibilityHint
    }
    set(newHint) {
      accessibilityView.accessibilityHint = newHint
    }
  }
  
  open override var accessibilityValue : String? {
    get {
      return accessibilityView.accessibilityValue
    }
    set(newHint) {
      accessibilityView.accessibilityValue = newHint
    }
  }
  
  open override var accessibilityElements: [Any]? {
    get {
      if (closed) {
        return [accessibilityView]
      } else {
        return [accessibilityView] + items
      }
    }
    set {
      
    }
  }
}

