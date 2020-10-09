//
//  AppDelegate.swift
//  RRSwiftListingWithoutStoryboard
//
//  Created by Rahul Mayani on 11/08/20.
//  Copyright © 2020 RR. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var realm = try? Realm()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        realmMigration()
        realm = try! Realm()
        
        DependencyManager.shared.registerDefaults()
         
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintAdjustmentMode = .normal
        let navPage = NavigationPage(rootViewController: ListingVC())
        navPage.statusBarStyle = .default
        window?.rootViewController = navPage
        window?.makeKeyAndVisible()
        
        return true
    }
}

// MARK: - Realm -
extension AppDelegate {
    
    private func realmMigration() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
         
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                    var nextID = 1
                    migration.enumerateObjects(ofType: RRDataModel.className()) { oldObject, newObject in
                        newObject!["id"] = "\(nextID)"
                        nextID += 1
                    }
                }
            })
         
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}
