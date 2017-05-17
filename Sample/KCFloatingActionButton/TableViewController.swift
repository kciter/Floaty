//
//  TableViewController.swift
//  KCFloatingActionButton-Sample
//
//  Created by LeeSunhyoup on 2016. 9. 21..
//  Copyright © 2016년 kciter. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, FloatyDelegate {
    
    var floaty = FloatyManager.defaultInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutFAB()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func layoutFAB() {
        let fab = FloatyManager.defaultInstance().button
        
        fab.openAnimationType = .none
        
        fab.itemSize = 30.0
        fab.solidCircleRadius = 25.0
        fab.buttonColor = UIColor(red: 0, green: 137/255.0, blue: 255/255.0, alpha: 1)
        fab.solidCircleColor = UIColor(red: 0, green: 137/255.0, blue: 255/255.0, alpha: 1)
        fab.buttonImage = UIImage(named: "icMap")
        
        fab.titleFontNormal = UIFont.systemFont(ofSize: 24)
        fab.titleFontSelected = UIFont.systemFont(ofSize: 30)
        fab.overlayColor = UIColor.black.withAlphaComponent(0.1)
        fab.itemShadowColor = UIColor.clear
        fab.cogButton.backgroundColor = UIColor.green
        fab.cogButtonSlideDistance = 100.0
        
        fab.buttonShadowColor = UIColor.clear
        fab.cogButton.addTarget(self, action: #selector(cogButtonTapped), for: .touchUpInside)
        
        fab.addItem(title: "Watch History") { (item) in
            if let idx = fab.items.index(of: item) {
                fab.selectedItemIdx = idx
            }
        }
        fab.addItem(title: "Series") { (item) in
            if let idx = fab.items.index(of: item) {
                fab.selectedItemIdx = idx
            }
        }
        fab.addItem(title: "Feed") { (item) in
            if let idx = fab.items.index(of: item) {
                fab.selectedItemIdx = idx
            }
        }
        
        fab.fabDelegate = self
        
        
//        let item = FloatyItem()
//        item.buttonColor = UIColor.blue
//        item.circleShadowColor = UIColor.red
//        item.titleShadowColor = UIColor.blue
//        item.title = "Custom item"
//        item.handler = { item in
//        }
//        
//        fab.addItem(title: "I got a title")
//        fab.addItem("I got a icon", icon: UIImage(named: "icShare"))
//        fab.addItem("I got a handler", icon: UIImage(named: "icMap")) { item in
//            let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Me too", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            self.fab.close()
//        }
//        fab.addItem(item: item)
        fab.sticky = true
        
        fab.fabDelegate = self
        
        print(tableView!.frame)
        
        floaty.show()
    }
    
    func cogButtonTapped() {
        print("cog button tapped")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        return cell
    }
    // MARK: - Floaty Delegate Methods
    func floatyOpened(_ floaty: Floaty) {
        print("Floaty Opened")
    }
    
    func floatyClosed(_ floaty: Floaty) {
        print("Floaty Closed")
    }
}
