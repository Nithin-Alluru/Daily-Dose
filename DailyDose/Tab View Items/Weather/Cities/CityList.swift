//
//  CityList.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/6/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import SwiftData

struct CityList: View {

    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<City>(sortBy: [SortDescriptor(\City.name, order: .forward)])) private var savedCities: [City]

    @Binding var selectedCity: City?
    // Allows dismissing the parent sheet
    @Binding var showCitySheet: Bool

    // City deletion
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: {
                        selectCity(newCity: nil)
                    }) {
                        HStack {
                            Image(systemName: "location")
                            Text("Current location")
                        }
                    }
                }
                Section(header: Text("Saved cities")) {
                    if savedCities.isEmpty {
                        Text("No saved cities")
                    } else {
                        ForEach(savedCities) { city in
                            Button(action: {
                                selectCity(newCity: city)
                            }) {
                                Text("\(city.name), \(city.regionName)")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onDelete(perform: delete)
                        .alert(isPresented: $showConfirmation) {
                            Alert(title: Text("Delete Confirmation"),
                                  message: Text("Are you sure you want to permanently delete this city from your saved list?"),
                                  primaryButton: .destructive(Text("Delete")) {
                                /*
                                 'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                  element to be deleted. It is nil if the array is empty. Process it as an optional.
                                 */
                                 if let index = toBeDeleted?.first {
                                     let itemToDelete = savedCities[index]
                                     modelContext.delete(itemToDelete)
                                 }
                                 toBeDeleted = nil
                             }, secondaryButton: .cancel() {
                                 toBeDeleted = nil
                             }
                         )}   // End of alert
                    }
                }
            }
            .navigationTitle("Select a Location")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SearchCities()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    func selectCity(newCity: City?) {
        selectedCity = newCity
        showCitySheet = false
    }

    /*
     --------------------------
     MARK: Delete Selected Item
     --------------------------
     */
    private func delete(at offsets: IndexSet) {
        toBeDeleted = offsets
        showConfirmation = true
    }

}
