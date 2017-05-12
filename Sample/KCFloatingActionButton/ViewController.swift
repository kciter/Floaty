//
//  ViewController.swift
//  KCFloatingActionButton
//
//  Created by LeeSunhyoup on 2015. 10. 4..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FloatyDelegate {
    
    var floaty = Floaty()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        layoutFAB()
    }

    @IBAction func endEditing() {
        view.endEditing(true)
    }
    
    @IBAction func customImageSwitched(_ sender: UISwitch) {
        if sender.isOn == true {
            floaty.buttonImage = UIImage(named: "custom-add")
        } else {
            floaty.buttonImage = nil
        }
    }
    
//    func layoutFAB() {
//        floaty.itemSize = 25.0
//        floaty.buttonImage = UIImage(named: "icMap")
//        floaty.buttonColor = UIColor.brown
//        
//        let item = FloatyItem()
//        item.buttonColor = UIColor.blue
//        item.circleShadowColor = UIColor.red
//        item.titleShadowColor = UIColor.blue
//        item.title = "Custom item"
//        item.handler = { item in
//            
//        }
//        
//        floaty.addItem(title: "Watch History")
//        floaty.addItem(title: "Series")
//        floaty.addItem(title: "Feed")
//        
//        floaty.fabDelegate = self
//        
////        self.view.addSubview(floaty)
//
//    }
    
    func floatyOpened(_ floaty: Floaty) {
        print("Floaty Opened")
    }
    
    func floatyClosed(_ floaty: Floaty) {
        print("Floaty Closed")
    }
}
