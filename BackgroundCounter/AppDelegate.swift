//
//  AppDelegate.swift
//  BackgroundCounter
//
//  Created by Jeonghoon Oh on 2023/07/11.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(0, forKey: "count")
        // Override point for customization after application launch.
        // 1. App Refresh Task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.runnan.background_fetch", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.runnan.background_fetch_long", using: nil) { task in
            self.handleLongAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        // 2. Processing Task
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.nearbrain.CLTester.refresh_process", using: nil) { task in
//            self.handleProcessingTask(task: task as! BGProcessingTask) // 타입 캐스팅 유의 (BG'Processing'Task)
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        let value = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(value + 1, forKey: "count")
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "two"), object: nil)
        }
        task.setTaskCompleted(success: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "three"), object: nil)
    }
    func handleLongAppRefresh(task: BGAppRefreshTask) {
        UserDefaults.standard.set(20000, forKey: "count")
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "two"), object: nil)
        }
        task.setTaskCompleted(success: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "three"), object: nil)
    }
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.runnan.background_fetch")

        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "one"), object: nil)
            // Set a breakpoint in the code that executes after a successful call to submit(_:).
        } catch {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fail"), object: nil)
            print("\(Date()): Could not schedule app refresh: \(error)")
        }
    }
    func scheduleLongAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.runnan.background_fetch_long")

        request.earliestBeginDate = Date(timeIntervalSinceNow: 12 * 60 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "one"), object: nil)
            // Set a breakpoint in the code that executes after a successful call to submit(_:).
        } catch {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fail"), object: nil)
            print("\(Date()): Could not schedule app refresh: \(error)")
        }
    }

}

