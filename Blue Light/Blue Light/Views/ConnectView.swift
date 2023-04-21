//
//  ConnectView.swift
//  Blue Light
//
//  Created by Frankie Tucker on 25/02/2023.
//
//  CONNECT VIEW
// - Connect view combines ConnectButton and CountdownTimer
// - ConnectButton monitors if the user wants to connect to the arduino and either calls a connect or disconnect function from the bluetooth controller class
//
//
//
//      SCAN WANTED = FALSE WHEN 30 MINS COMPLETE
//

import Foundation
import SwiftUI
import CoreBluetooth

struct ConnectView: View {
    
    @EnvironmentObject var bleController : BluetoothController
    @EnvironmentObject var dataController : DataController
    
    var body: some View {
        NavigationView {
            VStack {
                CountdownTimer()
                ConnectButton()
                .padding(50)
                Text(bleStatusText(status: bleController.bluetoothStatus))
                    .padding(0.5)
                Text(connectionStatusText(status: bleController.connectionStatus))
            }
            .padding(10)
            .navigationTitle("Connect")
            //.navigationTitle(statusText(status: bleController.connectionStatus))
        }
    }
    
   //------- Functions to display connection status --------
    
    private func bleStatusText(status:String) -> String{
        return("Bluetooth Status  --> \(status)")
    }
    
    private func connectionStatusText(status:String) -> String{
        if status == ""{
            return("")
        }
        else{
            return("Connection status --> \(status)")
        }
    }

    private func statusText(status: String) -> String {
        //let text = ""
        if status == ""{
            return("Connect")
        }
        else{
            return("Connection Status = \n \(status)")
        }
    }
      //-------------------------------------------------
}

struct ConnectButton: View {
    
    @EnvironmentObject var bleController : BluetoothController
    // holds state of button
    @State var scanWanted: Bool = false
    
    var body: some View {
        Button(action: {
            scanWanted.toggle()
            print("scanWanted Value =",String(scanWanted))
            if scanWanted {
                bleController.scanConnect()
            }
            else {
                bleController.disconnect()
            }
           
        }){
            Text(scanWanted ? connectedQMText(status: bleController.connectionStatus) : "Connect")
            //Text(scanWanted ? (bleController.lightOn ? " ": " ") : "Connect")
                .font(.system(size: 25, weight: .semibold, design: .monospaced))
                .padding()
                .background(Color((UIColor.systemGray6)))
                .cornerRadius(40)
                .foregroundColor(.black)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.black, lineWidth: 4)
                )
        }
    }
    
    private func connectedQMText(status:String) -> String{
        // function changes text on connection button
        if status == "Connected"{
            return("Connected")
        }
        else{
            return("connecting")
        }
    }
}

struct CountdownTimer: View {
    
    @EnvironmentObject var bleController : BluetoothController
    @EnvironmentObject var dataController : DataController
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var timeRemaining = 1800
    @State private var timerString = "30:00"
  
    var body: some View {

        Text(self.timerString)
            //.fontWeight(.semibold)
            .font(.system(size: 50, weight: .semibold, design: .monospaced))
            //.font(Font.system(.largeTitle, design: .monospaced))
            .padding(40)
            .background(Color((UIColor.systemGray6)))
            .cornerRadius(40)
            .foregroundColor(.black)
            .padding(15)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(bleController.lightOn ? Color.blue : Color.purple, lineWidth: 7)
            )
            .onReceive(timer) { time in
                if self.bleController.connectionStatus == "Connected" {
                    if self.bleController.lightOn {
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                            timerString = timeFormatterMS(timeRemaining)
                        }
                        else {
                            print(" 30 minutes wearing glasses complete")
                            // This mean 30 mins is complete
                            // --> bool stored to firestore
                            // --> disconnects from device

                            
                            bleController.disconnect()
                            dataController.storeLightData()
                            // MAKE SKAN WANTED = FALSE
                            
                            // -->add notification to user
                            // -->add somthing on screen
                        }
                        timerString = timeFormatterMS(timeRemaining)
                    }
                }
                else{
                    //print("disconnected")
                    //print("Potentially switch on glasses turned off")
                }
            }
        }
    
    // ------- fucntions for timer -----------------------

    func timeFormatterMS(_ val: Int) -> String {
        // time formatter minutes seconds
            
           //converts int:seconds into string:"minutes:seconds"
           let min = (val % 3600) / 60
           let sec = (val % 3600) % 60
           var timeAsString = ""
       
           timeAsString += String(format: "%02d", min)
           timeAsString += ":"
           timeAsString += String(format: "%02d", sec)
           return timeAsString
       }
    // --------------------------------------------------------
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView()
        .environmentObject(BluetoothController())
        .environmentObject(DataController())
        //  propertys with modifier required for preview
    }
}
