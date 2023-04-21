//
//  ContentView.swift
//  Blue Light
//
//  Created by Frankie Tucker on 25/02/2023.
//
//
//
//

import SwiftUI
import Foundation
import Firebase

struct ContentView: View {
   
    @StateObject var bleController = BluetoothController()
    @StateObject var dataController = DataController()
    //var bleController = BluetoothController()
    //var dataController = DataController()
    
    var body: some View {
        TabView {
            ConnectView()
                .tabItem{
                    Image(systemName: "eyeglasses")
                    Text("Connect")
                }
            QuizView()
                .tabItem{
                    Image(systemName: "moon")
                    Text("Sleep Quiz")
                }
            ShowDataView()
                .tabItem{
                    Image(systemName: "book.closed")
                    Text("data")
                }
            SettingsView()
                .tabItem{
                    Image(systemName: "ellipsis.rectangle.fill")
                    Text("settings")
                }
            }
        .environmentObject(bleController)
        .environmentObject(dataController)
      }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(BluetoothController())
        .environmentObject(DataController())
    }
}
