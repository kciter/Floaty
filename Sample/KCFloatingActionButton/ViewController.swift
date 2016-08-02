//
//  ViewController.swift
//  KCFloatingActionButton
//
//  Created by LeeSunhyoup on 2015. 10. 4..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KCFloatingActionButtonDelegate {
    
    var fab = KCFloatingActionButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutFAB()
    }

    @IBAction func endEditing() {
        view.endEditing(true)
    }
    
    @IBAction func customImageSwitched(sender: UISwitch) {
        if sender.on == true {
            fab.buttonImage = UIImage(named: "custom-add")
        } else {
            fab.buttonImage = nil
        }
    }
    
    func layoutFAB() {
        let item = KCFloatingActionButtonItem()
        item.buttonColor = UIColor.blueColor()
        item.circleShadowColor = UIColor.redColor()
        item.titleShadowColor = UIColor.blueColor()
        item.title = "Custom item"
        item.handler = { item in
            
        }
        
        fab.addItem(title: "I got a title")
        fab.addItem("I got a icon", icon: UIImage(named: "icShare"))
        fab.addItem("I got a handler", icon: UIImage(named: "icMap")) { item in
            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Me too", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.fab.close()
        }
        fab.addItem(item: item)
        fab.fabDelegate = self
        
        self.view.addSubview(fab)

    }
    
    func KCFABOpened(fab: KCFloatingActionButton) {
        print("FAB Opened")
    }
    
    func KCFABClosed(fab: KCFloatingActionButton) {
        print("FAB Closed")
    }
}