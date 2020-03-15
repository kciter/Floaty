//
//  CircularAnimationViewController.swift
//  KCFloatingActionButton-Sample
//
//  Created by MBP on 10/02/2020.
//  Copyright © 2020 kciter. All rights reserved.
//

import UIKit

class CircularAnimationViewController: UIViewController, FloatyDelegate {

    var floatyQuad = Floaty()
    var floatyCircular = Floaty()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // For QuadCircularAnimaition
        layoutFABforQuadAnimation(floaty: floatyQuad)
        floatyQuad.addDragging()
        floatyQuad.openAnimationType = .quadCircular // define animation type
        floatyQuad.circleAnimationDegreeOffset = 10 // define offset in degrees
        floatyQuad.circleAnimationRadius = 120 // by default is 150
        
        // For SemiCirularAnimation uncomment this code and comment the QuadCircularAnimaition code. Only one floaty button will work at a time
//        layoutFABforSemiCircleAnimation(floaty: floatyCircular)
//        floatyCircular.addDragging()
//        floatyCircular.openAnimationType = .semiCircular // define animation type
//        floatyCircular.circleAnimationDegreeOffset = 15 // define offset in degrees
        
        // For full circle top and bottom title
//        layoutFABforFullCircleAnimation()
    }
    
    func layoutFABforQuadAnimation(floaty : Floaty) {
        floaty.hasShadow = false
        floaty.paddingX = floaty.frame.width
        floaty.fabDelegate = self
        
        let item = FloatyItem()
        item.buttonColor = UIColor.blue
        
        floaty.addItem("", icon: UIImage(named: "icShare"))
        floaty.addItem("", icon: UIImage(named: "icMap")) { item in
        let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        floaty.addItem(item: item)
        
        self.view.addSubview(floaty)
    }
    
    func layoutFABforSemiCircleAnimation(floaty : Floaty) {
        floaty.buttonImage = UIImage(named: "custom-add")
        floaty.hasShadow = false
        floaty.paddingX = self.view.frame.width/2 - floaty.frame.width/2
        floaty.paddingY = self.view.frame.height/2 - floaty.frame.height/2
        floaty.fabDelegate = self
        
        let item = FloatyItem()
        item.buttonColor = UIColor.blue
        
        floaty.addItem("", icon: UIImage(named: "icShare"))
        floaty.addItem("", icon: UIImage(named: "icMap")) { item in
        let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        floaty.addItem(item: item)
        floaty.addItem("", icon: UIImage(named: "icShare"))
        floaty.addItem("", icon: UIImage(named: "icMap"))
        floaty.addItem("", icon: UIImage(named: "icShare"))
        floaty.addItem("", icon: UIImage(named: "icMap"))
        
        self.view.addSubview(floaty)
    }
    
    func layoutFABforFullCircleAnimation() {
        let floaty = Floaty()
        floaty.addDragging()
        floaty.circleAnimationRadius = 100
        floaty.openAnimationType = .slideUp
        floaty.circleAnimationDegreeOffset = 15
        
        floaty.buttonImage = UIImage(named: "custom-add")
        floaty.hasShadow = false
        floaty.paddingX = self.view.frame.width/2 - floaty.frame.width/2
        floaty.paddingY = self.view.frame.height/2 - floaty.frame.height/2
        floaty.fabDelegate = self
        
        self.view.addSubview(floaty)
        
        for index in 0...6 {
            let item = FloatyItem()
            item.buttonColor = .lightGray
            if index.isMultiple(of: 2) {
                item.title = "Map"
                item.icon = UIImage(named: "icMap")
                
            } else {
                item.title = "Share"
                item.icon = UIImage(named: "icShare")
            }
            item.titleLabelPosition = .bottom // .top
            floaty.addItem(item: item)
        }
    }
    
    // MARK: - Floaty Delegate Methods
    func floatyWillOpen(_ floaty: Floaty) {
      print("Floaty Will Open")
    }
    
    func floatyDidOpen(_ floaty: Floaty) {
      print("Floaty Did Open")
    }
    
    func floatyWillClose(_ floaty: Floaty) {
      print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
      print("Floaty Did Close")
    }

}
