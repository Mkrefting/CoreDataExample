//
//  ViewEditBill.swift
//  CoreDataExample
//
//  Created by Finnis on 23/04/2021.
//

import SwiftUI

struct ViewEditBill: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var bill: Bill
    
    @State var studentName: String = ""
    @State var block: String = ""
    @State var house: String = ""
    @State var naughtyRating: String = ""
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showingAlert: Bool = false
    
    let blocks = ["F", "E", "D", "C", "B"]
    let naughtyDeed = ["Not Bad", "Bad", "Very Bad"]
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Boy Details")) {
                    TextField(bill.studentName!, text: $studentName)
                    
                    TextField(bill.house!, text: $house)
                    
                    Picker(bill.block!, selection: $block) {
                        ForEach(blocks, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onAppear {
                        block = bill.block!
                    }
                }

                Section(header: Text("Naughty Rating")) {
                    Picker("Bill Severity", selection: $naughtyRating) {
                        ForEach(naughtyDeed, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onAppear {
                        naughtyRating = bill.naughtyRating!
                    }
                }

                Button(action: {
                    saveDetails()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Update Bill")
                }
            }
        }
        .navigationBarTitle("Update Bill", displayMode: .inline)
    }
    
    func saveDetails() {
        if studentName != bill.studentName && studentName != "" {
            bill.studentName = studentName
        }
        if block != bill.block && block != "" {
            bill.block = block
        }
        if house != bill.house && house != "" {
            bill.house = house
        }
        if naughtyRating != bill.naughtyRating && naughtyRating != "" {
            bill.naughtyRating = naughtyRating
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
}
