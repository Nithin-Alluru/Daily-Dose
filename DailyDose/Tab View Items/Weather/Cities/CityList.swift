//
//  CityList.swift
//  DailyDose
//
//  Created by CM360 on 12/6/23.
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

}
