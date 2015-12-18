//
//  EditItemViewController.swift
//  Shopping List
//
//  Created by Bart Jacobs on 18/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

protocol EditItemViewControllerDelegate {
    func controller(controller: EditItemViewController, didUpdateItem item: Item)
}

class EditItemViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    
    var item: Item!
    
    var delegate: EditItemViewControllerDelegate?
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Save Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save:")
        
        // Populate Text Fields
        nameTextField.text = item.name
        priceTextField.text = "\(item.price)"
    }
    
    // MARK: -
    // MARK: Actions
    func save(sender: UIBarButtonItem) {
        if let name = nameTextField.text, let priceAsString = priceTextField.text, let price = Float(priceAsString) {
            // Update Item
            item.name = name
            item.price = price
            
            // Notify Delegate
            delegate?.controller(self, didUpdateItem: item)
            
            // Pop View Controller
            navigationController?.popViewControllerAnimated(true)
        }
    }

}
