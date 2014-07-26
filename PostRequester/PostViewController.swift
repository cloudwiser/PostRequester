//
//  ViewController.swift
//  PostRequester
//
//  Created by Nick on 19/06/2014.
//  Copyright (c) 2014 cloudwise. All rights reserved.
//

import UIKit
import Foundation

class PostViewController: UIViewController {
                            
    @IBOutlet var statusLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Register for status notification
        // let myAppName = NSBundle.mainBundle().infoDictionary.objectForKey(kCFBundleNameKey) as String
        let myAppName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as String
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "statusHandler:", name: String("\(myAppName)_active"), object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "statusHandler:", name: String("\(myAppName)_inactive"), object: nil)
    }
    
    func statusHandler(notification: NSNotification) {
        statusLabel!.text = "\(notification.name)..."
    }
}

