//
//  SearchCities.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/6/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct SearchCities: View {

    // Allow dismissing this view
    @Environment(\.dismiss) private var dismiss

    @Environment(\.modelContext) private var modelContext

    // Search UI states
    @State private var searchFieldValue = ""
    @State private var firstSearchAttempted = false
    @State private var doingSearch = false
    @State private var cityResults: [UnresolvedCityStruct]?

    // Allows showing extra progress view for city location resolution
    @State private var resolvingCity: UnresolvedCityStruct?

    @State private var showAlertMessage = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Search for a city")) {
                    HStack {
                        TextField("Enter a search query", text: $searchFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        // Button to run a search
                        Button(action: {
                            let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
                            if queryTrimmed.isEmpty {
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a search query."
                                showAlertMessage = true
                            } else if doingSearch {
                                alertTitle = "Search Already in Progress!"
                                alertMessage = "Please wait for it to finish before starting another."
                                showAlertMessage = true
                            } else {
                                queryCities(query: queryTrimmed)
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                }
                if firstSearchAttempted {
                    Section(header: HStack {
                        Text(doingSearch ? "Searching..." : "Search results")
                    }) {
                        if let results = cityResults {
                            if results.isEmpty {
                                SearchCitiesErrorView(text: "Got no results! Try entering another query.")
                            } else {
                                List {
                                    ForEach(results, id: \.self) { city in
                                        Button(action: {
                                            selectCity(city: city)
                                        }) {
                                            HStack {
                                                Text("\(city.name), \(city.regionName)")
                                                if let resolving = resolvingCity {
                                                    if resolving == city {
                                                        ProgressView()
                                                            .padding(.leading, 5)
                                                    }
                                                }
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        } else {
                            if doingSearch {
                                ProgressView()
                            } else {
                                SearchCitiesErrorView(text: "There was an error conducting the search! Please try again.")
                            }
                        }
                    }
                }
            } // End of Form
            .navigationTitle("Search Cities")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        } // End of NavigationStack
    }

    func queryCities(query: String) {
        Task {
            doingSearch = true
            firstSearchAttempted = true
            cityResults = queryUnresolvedCities(query: query)
            doingSearch = false
        }
    }

    func selectCity(city: UnresolvedCityStruct) {
        Task {
            resolvingCity = city
            if let resolvedCity = fetchResolvedCity(city: city) {
                modelContext.insert(resolvedCity)
                // dismiss() must be run on main thread
                DispatchQueue.main.sync {
                    dismiss()
                }
            } else {
                alertTitle = "Error Resolving City!"
                alertMessage = "There was an error while resolving the selected city's info! Please try again."
                showAlertMessage = true
            }
            resolvingCity = nil
        }
    }

}

struct SearchCitiesErrorView: View {

    let text: String

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(.red)
                .imageScale(.medium)
                .font(Font.title.weight(.regular))
                .padding(.trailing, 5)
            Text(text)
        }
    }

}

#Preview {
    SearchCities()
}
