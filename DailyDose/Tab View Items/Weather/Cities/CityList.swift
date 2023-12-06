//
//  CityList.swift
//  DailyDose
//
//  Created by CM360 on 12/6/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import MapKit

struct CityList: View {

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

                }
            }
            .navigationTitle("Select a Location")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    func selectCity(newCity: City?) {
        selectedCity = nil
        showCitySheet = false
    }

}
