//
//  ShoppingListViewController.swift
//  Shopping List
//
//  Created by Bart Jacobs on 18/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

class ShoppingListViewController: UITableViewController {
    
    let CellIdentifier = "Cell Identifier"
    
    var items = [Item]() {
        didSet {
            buildShoppingList()
        }
    }
    
    var shoppingList = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Title
        title = "Shopping List"
        
        // Load Items
        loadItems()
        
        // Register Class
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        // Add Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateShoppingList:", name: "ShoppingListDidChangeNotification", object: nil)
    }
    
    // MARK: -
    // MARK: Table View Data Source Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        // Fetch Item
        let item = shoppingList[indexPath.row]
        
        // Configure Table View Cell
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    // MARK: -
    // MARK: Notification Handling
    func updateShoppingList(notification: NSNotification) {
        loadItems()
    }
    
    // MARK: -
    // MARK: Helper Methods
    func buildShoppingList() {
        shoppingList = items.filter({ (item) -> Bool in
            return item.inShoppingList
        })
    }

    private func loadItems() {
        if let filePath = pathForItems() where NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [Item] {
                items = archivedItems
            }
        }
    }
    private func pathForItems() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if let documents = paths.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.URLByAppendingPathComponent("items").path
        }
        
        return nil
    }

}
