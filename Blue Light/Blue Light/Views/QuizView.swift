//
//  QuizView.swift
//  Blue Light
//
//  Created by Frankie Tucker on 25/02/2023.
//
//
//
//

import Foundation
import SwiftUI
import Firebase

struct QuizView: View {

    @EnvironmentObject var dataController : DataController
    
    @AppStorage("userID") var userID: String = "EMPTY"
    @State private var dateOfMorning: Date = Date()
    @State private var dateOfMorningString: String = ""
    
    @State private var newData: DataForDate = .empty
    let db = Firestore.firestore()
    let dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: Date())//, from: triggerDate)
    
    var body: some View {
       
        NavigationView {
            
                Form {
                    Section(header: Text("User : \(userID) ")) {
                        
                        DatePicker("Todays date :",
                                   selection: $dateOfMorning, in: ...Date.now, displayedComponents: .date)
                        
                        VStack(alignment: .leading){
                            Text("The time you went to bed last night:")  .multilineTextAlignment(.leading)
                                
                            DatePicker(" ",
                                       selection: $newData.bedTime, in:dateOfMorning.addingTimeInterval(-2*60*60*24)...dateOfMorning, displayedComponents: [.date, .hourAndMinute])
                        }
                        
                        VStack(alignment: .leading){
                            Text("The time you got up this morning :")
                            DatePicker(" ",
                                       selection: $newData.getUpTime,in:newData.bedTime...newData.bedTime.addingTimeInterval(2*60*60*24), displayedComponents: [.date, .hourAndMinute])//.labelsHidden()
                        }
                        Stepper(value: $newData.sleepOnsetTime,
                                in: 0...240,
                                step: 5,
                                label: {
                            Text("Time it took to fall asleep :\n  \(newData.sleepOnsetTime) minutes")
                        })
                        Stepper(value: $newData.wakeUpNum,
                                in: 0...20,
                                step: 1,
                                label: {
                            Text("Times you woke up during the night :\n  \(newData.wakeUpNum) times")
                        })
                        Stepper(value: $newData.totalWakeUpTime,
                                in: 0...240,
                                step: 5,
                                label: {
                            Text("Total time you were awake during the night :\n  \(newData.totalWakeUpTime) minutes")
                        })
                        TextField(text: $newData.otherInfo, prompt: Text("Any other info?...")) {
                            Text("$newData.otherInfo")
                        }
                        Section{
                            Button("Save"){
                                if self.isUserInformationValid() {
                                    
                                    // caculating values
                                    newData.inBedTotal = totalTimeBedCalc(bedTime: newData.bedTime, upTime: newData.getUpTime)
                                    newData.totalSleepTime = totalSleepCalc(total: newData.inBedTotal, awake1: newData.totalWakeUpTime, awake2: newData.sleepOnsetTime)
                                    
                                    // date is used as document name to save sleep data to
                                    dateOfMorningString = dateFormatter(date: dateOfMorning)
                                    
                                    // saving data
                                    dataController.saveSleepData(dataForDate: newData,  stringDate: dateOfMorningString)
                                    
                                    // resetting quiz input values so the form looks nice
                                    newData = DataForDate.empty
                                    dateOfMorning = Date()
                                }
                            }
                            
                            
                        }
                    }
                   
                }
                .navigationTitle(Text("Sleep Quiz"))
            }
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color(UIColor.systemGray6))             // * change background colour
    }
    
    private func isUserInformationValid() -> Bool {
       // if userName.isEmpty {
        //    return false
        //}
        
        // check bedtime is before wake up time
        // check interval is reasonable
        // check if theres already data for this date
        
        return true
    }
    
}

// --- Functions used to calculate sleep data which is derived from input data ---

func totalTimeBedCalc(bedTime: Date, upTime: Date) -> Int{
    // returns interval between 2 dates in minutes
    let minutes = Int(upTime.timeIntervalSince(bedTime)/60)
    return(minutes)
}

func totalSleepCalc(total:Int,awake1:Int,awake2:Int) -> Int{
    // returns total sleep time in minutes
    let totalSleep = total - awake1 - awake2
    return(totalSleep)
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
            .environmentObject(BluetoothController())
            .environmentObject(DataController())
    }
}

