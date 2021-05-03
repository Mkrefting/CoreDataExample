//
//  UpcomingBillsView.swift
//  CoreDataExample
//
//  Created by Finnis, Jack (PGW) on 19/03/2021.
//

import SwiftUI

struct UpcomingBillsView: View {
    @State var searchText: String = ""
    
    @State var showingAddToBillView: Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // To fetch the bills data
    @FetchRequest(entity: Bill.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Bill.block, ascending: false)])
    var bills: FetchedResults<Bill>
    
    let naughtyDeed = ["Not Bad", "Bad", "Very Bad"]
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                List {
                    ForEach(self.bills.filter {
                        self.searchText.isEmpty ? true : ($0.studentName!.contains(self.searchText) || $0.house!.contains(self.searchText) || $0.block!.contains(self.searchText))
                    }, id: \.self) { bill in
                        NavigationLink(destination: ViewEditBill(bill: bill), label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(bill.studentName!)
                                        .font(.headline)
                                    Text(bill.house!)
                                        .font(.caption)
                                    Text("\(bill.block!) Block")
                                        .font(.caption)
                                }
                                Spacer()
                                if bill.naughtyRating! == "Very Bad" {
                                    Text(bill.naughtyRating!)
                                        .font(.headline)
                                        .foregroundColor(.red)
                                } else if bill.naughtyRating! == "Bad" {
                                    Text(bill.naughtyRating!)
                                        .font(.headline)
                                        .foregroundColor(.orange)
                                } else {
                                    Text(bill.naughtyRating!)
                                        .font(.headline)
                                        .foregroundColor(.green)
                                }
                            }
                        })
                    }.onDelete(perform: { indexSet in
                        for index in indexSet {
                            managedObjectContext.delete(bills[index])
                        }
                        do {
                            try managedObjectContext.save()
                        } catch {
                            print("Error")
                        }
                    })
                }
                .navigationBarTitle("Upcoming Bills")
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showingAddToBillView.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showingAddToBillView, content: {
                        AddToBillView(showingAddToBillView: $showingAddToBillView)
                    })
                )
            }
        }
    }
}
