//
//  DataModels.swift
//  Blue Light
//
//  Created by Frankie Tucker on 17/03/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct DataForDate: Codable, Identifiable {
    // Instances of struct used to store data to db and map data from db
    // extension used as initialiser required
    
    @DocumentID var id: String?
    var bedTime: Date
    var getUpTime: Date
    var sleepOnsetTime: Int
    var wakeUpNum: Int
    var totalWakeUpTime: Int
    var inBedTotal: Int
    var totalSleepTime: Int
    var otherInfo: String
}
extension DataForDate {
    static let empty =  DataForDate(bedTime: Date(), getUpTime: Date(), sleepOnsetTime: 0, wakeUpNum: 0, totalWakeUpTime: 0, inBedTotal: 0, totalSleepTime: 0, otherInfo: " ")
}

struct GlassWornData: Codable {
    @DocumentID var id: String?
    var glassesWorn: Bool
}
extension GlassWornData {
    static let newData = GlassWornData(glassesWorn: false)
}
