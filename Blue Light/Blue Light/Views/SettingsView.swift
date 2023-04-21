//
//  Blue Light, SettingsView.swift
//  Created by Frankie Tucker on 02/03/2023.
//
// View's control setting page of tab
//
//

import SwiftUI
import Foundation
import UserNotifications

struct SettingsView: View {
    
    @State var notificationsWanted = false
    @State var notificationsSet = false
    @State var notificationTime = Date()
    
    @EnvironmentObject var dataController : DataController
    
    //@State private var studyID: String = "Enter Study Number"
    @AppStorage("studyID") var studyID: String = ""
    //let center = UNUserNotificationCenter.current()

    var body: some View {
        
        NavigationView{
            VStack{
                Button(action: {
                    
                    notificationsWanted.toggle()
                    
                    if notificationsWanted {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        
                        if success {
                            
                            notificationsSet = true
                            print("Notifications wanted = \(notificationsWanted) at time \(notificationTime) ")
                            let notificationContent = UNMutableNotificationContent()
                            notificationContent.title = "Reminder!!"
                            notificationContent.subtitle = "Have you worn your Blue light glasses today?"
                            notificationContent.sound = UNNotificationSound.default
                           // add condition if glasses have beeen worn
                           
                            let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
                           
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
                            UNUserNotificationCenter.current().add(request)

                        } else if let error = error {
                            notificationsSet = false
                            notificationsWanted = false
                            print(error.localizedDescription)
                        }
                    }
                }
                    else {
                        // case where notifications not wanted
                        notificationsSet = false
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }
                    
                }){
                    
                    Text(notificationsSet ? "Notifictions Set" : "Set Notifications")
                        .font(.system(size: 25, weight: .semibold, design: .monospaced))
                        .padding()
                        .background(Color((UIColor.systemGray6)))
                        .cornerRadius(40)
                        .foregroundColor(.black)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(notificationsSet ? Color.green : Color.purple, lineWidth: 4)
                    )
                }
                
                DatePicker("Select Time:",
                           selection: $notificationTime, displayedComponents: .hourAndMinute)
                    .fixedSize()
                    .font(.system(size: 22, weight: .semibold, design: .monospaced))
                    .padding()
                    .background(Color((UIColor.systemGray6)))
                    .cornerRadius(40)
                    .foregroundColor(.black)
                    .padding(10)
             
                
                //Text("device identifier uuid :  \(self.deviceID)")
                
                TextField(
                     " Enter Study Number     ",
                     text: $studyID
                 )
                 .onSubmit {
                     dataController.storeStudyID(newID: studyID)
                   }
                
                 .textInputAutocapitalization(.never)
                 .disableAutocorrection(true)
                 .fixedSize()
                 .font(.system(size: 18, weight: .semibold, design: .monospaced))
                 .padding()
                 .background(Color((UIColor.systemGray6)))
                 .cornerRadius(40)
                 .foregroundColor(.black)
                 .padding(10)
    
            }
            .padding(10)
            .navigationTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
/*
func whatColour(userBool : Bool) -> String {
    var labelColour = " "
    if userBool == true {
        labelColour = Color.green
    }
    else{
        labelColour = Color.red
    }
    return(labelColour)
}
*/


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
