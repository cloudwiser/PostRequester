//
//  AppDelegate.swift
//  PostRequester
//
//  Created by Nick on 19/06/2014.
//  Copyright (c) 2014 cloudwise. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:4567/login"))
    var session = NSURLSession.sharedSession()
    var myTimer: NSTimer?
    var activeNotification: NSNotification?
    var inactiveNotification: NSNotification?
    let timeInterval = 3 as NSTimeInterval
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
        var params = ["username":"nick", "password":"password"] as Dictionary
        var err: NSError?
        
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let myAppName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName")? as NSString

        // let myAppName = NSBundle.mainBundle().infoDictionary.objectForKey(kCFBundleNameKey) as String
        // let myAppName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as String
        self.activeNotification = NSNotification(name: String("\(myAppName)_active"), object: nil)
        self.inactiveNotification = NSNotification(name: String("\(myAppName)_inactive"), object: nil)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        myTimer?.invalidate()
        NSNotificationCenter.defaultCenter().postNotification(self.inactiveNotification)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "timerTicked", userInfo: nil, repeats: true)
        NSNotificationCenter.defaultCenter().postNotification(self.activeNotification)

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func timerTicked() {
        var task = self.session.dataTaskWithRequest(self.request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            if error {
                println(error.localizedDescription)
            }
            else {
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
                
                if(err) {
                    println(err!.localizedDescription)
                }
                else {
                    var success = json["success"] as? Int
                    println("Success: \(success)")
                }
            }
        })
        task.resume()
    }
}

