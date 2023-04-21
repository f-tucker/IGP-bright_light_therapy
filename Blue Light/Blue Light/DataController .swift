//  Blue Light
//  DataController.swift
//  Created by Frankie Tucker on 14/03/2023.
//
//   DATACONTROLLER class, essentially a view model
//  -- manages firestore database interactions through 4 functions allowing :
//  --> Storing sleep data
//  --> Retrival of sleep data from DB
//  --> Storing LightData
//  --> Retriving LightData from DB
//
//   Light data is writen to fields in uneque document rather than the same document as sleep date
//    since it is missleading to 
//
//
// - DB structure:
//     Collections:     Documents in      Fields in documents:
//                      Collection:
//                                         |---> bedTime:Date
//                                         |---> getUpTime:Date
//     - userID1        |---> date1 ------>|---> sleepOnsetTime:Int...
//     - userID2 =======|---> date2        |--->   ...
//     - userID3..      |---> date3...
//     - ...            |--->   ...          |---> date1:True
//                      |---> Light data --->|---> date2:True..
//                      |                    |--->      ...
//                      |---> StudyID ---> studyID:String

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestoreSwift


class DataController: ObservableObject {
    
    @Published var dateSelector = Date()
    @Published var lightDataString: String = " "
    
    @AppStorage("userID") var userID: String = "EMPTY"
    @Published var sleepErrorMessage: String?
    
    // Instance of codable structure to map firestore data to
    @Published var dataForDate: DataForDate = .empty
    private var documentId: String = " "
    private var db = Firestore.firestore()

    //private var listenerRegistration: ListenerRegistration?
    
    func saveSleepData(dataForDate: DataForDate, stringDate: String){
        // --> users sleep data is stored to db
        
        let docRef = db.collection(userID).document(stringDate)
        do {
            try docRef.setData(from: dataForDate)
            print("new data added ")
        }
        catch {
            print(error)
        }
    }
    
    // Accesses whole document
    func fetchSleepData(stringdate: String) {
        // --> Returns Sleep Data
        // -Function takes date as a string
        // -Sleep data for specified date is mapped to codable structure
     let docRef = db.collection(userID).document(stringdate)
      
      docRef.getDocument(as: DataForDate.self) { result in
        switch result {
        case.success(let dataForDate):
          self.dataForDate = dataForDate
          self.sleepErrorMessage = nil
        case.failure(let error):
          self.sleepErrorMessage = "Error Getting Document: \(error.localizedDescription)"
        }
      }
    }
    
    func storeLightData(){
            // --> stores light data
            // no initialiaser as only stored if glasses worn for 30 mins, and date is always 'today'
           
            let today = dateFormatter(date: Date())
            let lightData: [String: Bool] = [today : true]
            let docRef = db.collection(userID).document("lightData")
            docRef.setData(lightData, merge: true)
        }
    
    
    // LightData document contains all light Exposure data, We only want entry for
    // specific date, so document no mapped
    func fetchLighData(stringdate: String) {
        // --> Returns Light Data
        // -Function takes date as a string
        // -Returns statement
        
        let docRef = db.collection(userID).document("lightData")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let wornQmark = data?[stringdate] as? Bool ?? false
                self.lightDataString = ("Glasses worn: \(wornQmark) ")
                print("Date: \(stringdate), Glasses worn: \(wornQmark ) ")
            } else {
                print("No light data for \(stringdate)")
                self.lightDataString = ("No Light Data")
            }
        }
    }
    
    func storeStudyID(newID: String) {
        // stores a new study ID if the user enters one
        let docRef = db.collection(userID).document("StudyID")
        docRef.setData(["studyID":newID], merge: true)
        
        
        
    
    }
}


