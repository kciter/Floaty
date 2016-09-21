//
//  TableViewController.swift
//  KCFloatingActionButton-Sample
//
//  Created by LeeSunhyoup on 2016. 9. 21..
//  Copyright © 2016년 kciter. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var fab = KCFloatingActionButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutFAB()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 30
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.fab.frame.origin.y = scrollView.contentOffset.y
//        self.view.bringSubview(toFront: fab)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if velocity.y > 0 {
//            self.fab.isHidden = true
//        } else {
//            self.fab.isHidden = false
//        }
    }
    
    func layoutFAB() {
        let item = KCFloatingActionButtonItem()
        item.buttonColor = UIColor.blue
        item.circleShadowColor = UIColor.red
        item.titleShadowColor = UIColor.blue
        item.title = "Custom item"
        item.handler = { item in
        }
        
        fab.addItem(title: "I got a title")
        fab.addItem("I got a icon", icon: UIImage(named: "icShare"))
        fab.addItem("I got a handler", icon: UIImage(named: "icMap")) { item in
            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.fab.close()
        }
        fab.addItem(item: item)
        fab.sticky = true
        
        print(tableView!.frame)
        
        self.view.addSubview(fab)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        return cell
    }

}
