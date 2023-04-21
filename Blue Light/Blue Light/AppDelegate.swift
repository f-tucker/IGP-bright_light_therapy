//
//  AppDelegate.swift
//  Blue Light
//
//  Created by Frankie Tucker on 08/03/2023.
//
//  APPDELEGATE CLASS
// - configures firebase
// - calls userID from appstorage, if this has not been called before userID is given a uuid to identify them
// - userID is persistent and used to identify where to store data
// - client requested no login, with strict apple regulations on identifiables this was best solution
//
//      *TESTING*
//device identifier for Vendor: D919A9F1-3595-426C-8CDA-909B6BBF44C3
//device identifier for system: 356D8FF8-B06C-471E-A5D1-A38255A67805

import Foundation
import UIKit
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift

class AppDelegate: NSObject, UIApplicationDelegate {
   
    @AppStorage("userID") var userID: String = "EMPTY"
    @Published var userVendorID: String = ""
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
            
        if userID == "EMPTY"  {
            userID = UUID().uuidString
        }
        
        let userVendorID = getVendorID()
        print("device identifier for Vendor: \(userVendorID)")
        print("device identifier for system: \(userID)")
        return true
    }
    
    private func getVendorID() -> String {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
           assertionFailure("failed to unwrap vender uuid")
           return ""}
        return uuid
    }
}


class UserIdentifierStore: ObservableObject {
    // putting user identifieables in class for better access
}
