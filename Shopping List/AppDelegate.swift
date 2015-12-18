//
//  AppDelegate.swift
//  Shopping List
//
//  Created by Bart Jacobs on 12/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Seed Items
        seedItems()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func seedItems() {
        let ud = NSUserDefaults.standardUserDefaults()
        
        if !ud.boolForKey("UserDefaultsSeedItems") {
            if let filePath = NSBundle.mainBundle().pathForResource("seed", ofType: "plist"), let seedItems = NSArray(contentsOfFile: filePath) {
                // Items
                var items = [Item]()
                
                // Create List of Items
                for seedItem in seedItems {
                    if let name = seedItem["name"] as? String, let price = seedItem["price"] as? Float {
                        print("\(name) - \(price)")
                        
                        // Create Item
                        let item = Item(name: name, price: price)
                        
                        // Add Item
                        items.append(item)
                    }
                }
                
                print(items)
                
                if let itemsPath = pathForItems() {
                    // Write to File
                    if NSKeyedArchiver.archiveRootObject(items, toFile: itemsPath) {
                        ud.setBool(true, forKey: "UserDefaultsSeedItems")
                    }
                }
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

