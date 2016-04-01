//
//  ViewController.swift
//  KCFloatingActionButton
//
//  Created by LeeSunhyoup on 2015. 10. 4..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KCFloatingActionButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let item = KCFloatingActionButtonItem()
        item.buttonColor = UIColor.blueColor()
        item.circleShadowColor = UIColor.redColor()
        item.titleShadowColor = UIColor.blueColor()
        item.title = "Custom item"
        
//        This object is dependent on the UIWindow.
//        KCFABManager.defaultInstance().getButton().addItem(title: "I got a title")
//        KCFABManager.defaultInstance().getButton().addItem("I got a icon", icon: UIImage(named: "icShare")!)
//        KCFABManager.defaultInstance().getButton().addItem("I got a handler", icon: UIImage(named: "icMap")!, handler: { item in
//            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "Me too", style: .Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//            KCFABManager.defaultInstance().getButton().close()
//        })
//        KCFABManager.defaultInstance().getButton().addItem(item: item)
//        KCFABManager.defaultInstance().getButton().items[1].hidden = true
//        KCFABManager.defaultInstance().show()
        
//        This object is dependent on the UIViewController.
        let fab = KCFloatingActionButton()
        fab.addItem(title: "I got a title")
        fab.addItem("I got a icon", icon: UIImage(named: "icShare")!)
        fab.addItem("I got a handler", icon: UIImage(named: "icMap")!, handler: { item in
            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Me too", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            fab.close()
        })
        fab.addItem(item: item)
        fab.fabDelegate = self
        self.view.addSubview(fab)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func endEditing() {
        view.endEditing(true)
    }
    
    func KCFABOpened(fab: KCFloatingActionButton) {
        print("FAB Opened")
    }
    
    func KCFABClosed(fab: KCFloatingActionButton) {
        print("FAB Closed")
    }
}