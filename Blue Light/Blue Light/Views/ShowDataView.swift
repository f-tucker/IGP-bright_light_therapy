//
//  ShowDataView.swift
//  Blue Light
//
//  Created by Frankie Tucker on 25/02/2023.
//
// ShowDataView compromised of Day selectorView and DataforDayView
//
// - DaySelectorView uses a datepicker Calander allowing the user to select a date
// - DataForDayView
//
//
import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ShowDataView: View {
    
    @EnvironmentObject var bleController : BluetoothController
    @EnvironmentObject var dataController : DataController
    
    var body: some View {
        NavigationView {
            VStack() {
                DaySelectorView()
                DataForDayView()
            }
            .padding(.vertical, 100)
            .navigationTitle("Data")
        }
        .navigationViewStyle(StackNavigationViewStyle()) // required to stop bug
        //.environmentObject(dataController)
    }
}


struct DaySelectorView: View {
    
    @State private var dateSelector = Date()
    @EnvironmentObject var dataController : DataController
    
    var body: some View {
        VStack{
            //Divider().frame(height: 1)
            DatePicker("Select Date...", selection: $dateSelector, displayedComponents: [.date])
                .padding(.horizontal)
                .datePickerStyle(.graphical)
                //.accentColor(.orange)
                .onChange(of: dateSelector) { _ in
                    
                    // when a different date is selected ..... fetch data functions are called
                    dataController.fetchSleepData(stringdate: dateFormatter(date: dateSelector))
                    dataController.fetchLighData(stringdate: dateFormatter(date: dateSelector))
                    print("-------------------")
       
                }
            Divider()
            Text(dateSelector.formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 28))
                .bold()
                .foregroundColor(Color.accentColor)
                .padding()
            }
        //.environmentObject(dataController)
        }
    }



struct DataForDayView: View {
    @EnvironmentObject var dataController : DataController
    //@StateObject var dataController = DataController()
    var body: some View {
        VStack(alignment: .leading){
            //Text("document id  ---  \( dataController.dataForDate.id)")
            Text("Bed Time:     \(timeFormatterHM(date: dataController.dataForDate.bedTime ))")
            Text("Wake Up Time:   \(timeFormatterHM(date: dataController.dataForDate.getUpTime ))")
            Text("Sleep onset time: \(dataController.dataForDate.sleepOnsetTime) minutes")
            Text("Times woken up:  \(dataController.dataForDate.wakeUpNum)")
            Text("Total time woken up: \(dataController.dataForDate.totalWakeUpTime) minutes")
            Text("Total time in Bed:  \(dataController.dataForDate.inBedTotal) minutes")
            Text("Total time asleep: \(dataController.dataForDate.totalSleepTime) minutes")
            Text("Comments: \(dataController.dataForDate.otherInfo)")
            //Text("---------")
            Text(" -- \(self.dataController.lightDataString) --")
            //Text("---------")
        }
    }
}
            
//  ------------ Time Formating Functions --------------

func dateFormatter(date: Date) -> String{
    // function formats date/time data into days.months.years string
    var stringDate = " "
    let dateFormatter = DateFormatter()
         // Set Date Format
    dateFormatter.dateFormat = "dd.MM.yy"
         // Convert Date to String
    stringDate = dateFormatter.string(from: date)
    return(stringDate)
}

func timeFormatterHM(date: Date) -> String{
    // time formatter hours and minutes
    // function formats time data into hours:minutes string
    
    var stringDate = " "
    let dateFormatter = DateFormatter()
         // Set Date Format
    dateFormatter.dateFormat = "HH:mm"
         // Convert Date to String
    stringDate = dateFormatter.string(from: date)
    return(stringDate)
}



struct ShowDataView_Previews: PreviewProvider {
    static var previews: some View {
        ShowDataView()
            .environmentObject(BluetoothController())
            .environmentObject(DataController())
    }
}



