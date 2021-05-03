//
//  AddToBillView.swift
//  CoreDataExample
//
//  Created by Finnis, Jack (PGW) on 17/03/2021.
//

import SwiftUI

struct AddToBillView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var showingAddToBillView: Bool
    @State var showingAlert: Bool = false
    
    @State var studentName: String = ""
    @State var block: String = ""
    @State var house: String = ""
    @State var naughtyRating: String = ""
    
    var displayName: String {
        if studentName == "" {
            return " "
        } else {
            return " " + studentName + " "
        }
    }
    
    let blocks = ["F", "E", "D", "C", "B"]
    let naughtyDeed = ["Not Bad", "Bad", "Very Bad"]
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Boy Details")) {
                    TextField("Name", text: $studentName)
                    
                    TextField("House", text: $house)
                    
                    Picker("Block", selection: $block) {
                        ForEach(blocks, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Naughty Rating")) {
                    Picker("Bill Severity", selection: $naughtyRating) {
                        ForEach(naughtyDeed, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Button(action: {
                    if studentName != "" && block != "" && house != "" && naughtyRating != "" {
                        let bill = Bill(context: self.managedObjectContext)
                        bill.studentName = studentName
                        bill.block = block
                        bill.house = house
                        bill.naughtyRating = naughtyRating
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                    } else {
                        showingAlert = true
                        return
                    }
                    self.showingAddToBillView = false
                }) {
                    Text("Add\(displayName)to the Bill")
                }.alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("Incomplete Details"), message: Text("Please enter the boy's name, block, house and naughty rating"), dismissButton: .default((Text("Dismiss"))))
                })
            }.navigationBarTitle("Add\(displayName)to the Bill", displayMode: .inline)
        }
    }
}
