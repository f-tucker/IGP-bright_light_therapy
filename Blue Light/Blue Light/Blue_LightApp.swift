//
//  Blue_LightApp.swift
//  Blue Light
//
//  Created by Frankie Tucker on 25/02/2023.
//
//
//  @main, AppDelegate class called and content view placed in scene
//  - enviromentObjects called later due to isssue with delegate firebase.confirguration() being called after dataController 
//
//

import SwiftUI
import UIKit
import Firebase

@main
struct Blue_LightApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appdelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


