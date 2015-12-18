//
//  ListViewController.swift
//  Shopping List
//
//  Created by Bart Jacobs on 12/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, AddItemViewControllerDelegate, EditItemViewControllerDelegate {
    
    let CellIdentifier = "Cell Identifier"
    
    var items = [Item]()
    var selection: Item?
    
    // MARK: -
    // MARK: Initialization
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Load Items
        loadItems()
    }
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Title
        title = "Items"
        
        // Register Class
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        // Create Add Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem:")
        
        // Create Edit Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editItems:")
    }
    
    // MARK: -
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItemViewController" {
            if let navigationController = segue.destinationViewController as? UINavigationController,
                let addItemViewController = navigationController.viewControllers.first as? AddItemViewController {
                    addItemViewController.delegate = self
            }
            
        } else if segue.identifier == "EditItemViewController" {
            if let editItemViewController = segue.destinationViewController as? EditItemViewController, let item = selection {
                editItemViewController.delegate = self
                editItemViewController.item = item
            }
        }
    }
    
    // MARK: -
    // MARK: Table View Data Source Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        // Fetch Item
        let item = items[indexPath.row]
        
        // Configure Table View Cell
        cell.textLabel?.text = item.name
        cell.accessoryType = .DetailDisclosureButton
        
        if item.inShoppingList {
            cell.imageView?.image = UIImage(named: "checkmark")
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete Item from Items
            items.removeAtIndex(indexPath.row)
            
            // Update Table View
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            
            // Save Changes
            saveItems()
        }
    }
    
    // MARK: -
    // MARK: Table View Delegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Fetch Item
        let item = items[indexPath.row]
        
        // Update Item
        item.inShoppingList = !item.inShoppingList
        
        // Update Cell
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if item.inShoppingList {
            cell?.imageView?.image = UIImage(named: "checkmark")
        } else {
            cell?.imageView?.image = nil
        }
        
        // Save Items
        saveItems()
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        // Fetch Item
        let item = items[indexPath.row]
        
        // Update Selection
        selection = item
        
        // Perform Segue
        performSegueWithIdentifier("EditItemViewController", sender: self)
    }
    
    // MARK: -
    // MARK: Add Item View Controller Delegate Methods
    func controller(controller: AddItemViewController, didSaveItemWithName name: String, andPrice price: Float) {
        // Create Item
        let item = Item(name: name, price: price)
        
        // Add Item to Items
        items.append(item)
        
        // Add Row to Table View
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: (items.count - 1), inSection: 0)], withRowAnimation: .None)
        
        // Save Items
        saveItems()
    }
    
    // MARK: -
    // MARK: Edit Item View Controller Delegate Methods
    func controller(controller: EditItemViewController, didUpdateItem item: Item) {
        // Fetch Index for Item
        if let index = items.indexOf(item) {
            // Update Table View
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
        }
        
        // Save Items
        saveItems()
    }
    
    // MARK: -
    // MARK: Actions
    func addItem(sender: UIBarButtonItem) {
        performSegueWithIdentifier("AddItemViewController", sender: self)
    }
    
    func editItems(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.editing, animated: true)
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func loadItems() {
        if let filePath = pathForItems() where NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [Item] {
                items = archivedItems
            }
        }
    }
    
    private func saveItems() {
        if let filePath = pathForItems() {
            NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
            
            // Post Notification
            NSNotificationCenter.defaultCenter().postNotificationName("ShoppingListDidChangeNotification", object: self)
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
