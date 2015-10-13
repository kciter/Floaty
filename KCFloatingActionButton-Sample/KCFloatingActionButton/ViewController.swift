//
//  ViewController.swift
//  KCFloatingActionButton
//
//  Created by LeeSunhyoup on 2015. 10. 4..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        KCFABManager.defaultInstance().getButton().addItem(title: "I got a title")
        KCFABManager.defaultInstance().getButton().addItem("I got a icon", icon: UIImage(named: "icShare")!)
        KCFABManager.defaultInstance().getButton().addItem("I got a handler", icon: UIImage(named: "icMap")!, handler: { item in
            print("OK!!!!!")
            KCFABManager.defaultInstance().getButton().close()
        })
        KCFABManager.defaultInstance().show()

//        This object is dependent on the controller.
//        let fab = KCFloatingActionButton(size: 56)
//        fab.addItem(title: "I got a title")
//        fab.addItem("I got a icon", icon: UIImage(named: "icShare")!)
//        fab.addItem("I got a handler", icon: UIImage(named: "icMap")!, handler: { item in
//            self.performSegueWithIdentifier("next", sender: nil)
//            self.fab.close()
//        })
//        self.view.addSubview(fab)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func endEditing() {
        view.endEditing(true)
    }
}