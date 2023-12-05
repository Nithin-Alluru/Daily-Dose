//
//  SearchComics.swift
//  DailyDose
//
//  Created by Nithin VT on 12/2/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import SwiftData

struct SearchComics: View {
    
    @State private var searchFieldValue = ""
    @State private var searchCompleted = false
    @State private var showAlertMessage = false
    
    let comicSearchCategories = ["Comic Published Date", "Comic Title", "Comic Transcript", "Comic Alternate Description"]
    
    @State private var selectedComicCategoryIndex = 0
    
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 40 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -40, to: Date())!
       
        // Set maximum date to 10 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        return minDate...maxDate
    }
    
    @State private var comicPublishedDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Select Search Category")) {
                    Picker("", selection: $selectedComicCategoryIndex) {
                        ForEach(0 ..< comicSearchCategories.count, id: \.self) {
                            Text(comicSearchCategories[$0])
                        }
                    }
                }
                if(selectedComicCategoryIndex == 0)
                {
                    Section(header: Text("Select Comic Published Date").padding(.top, 100)) {
                        DatePicker(
                            selection: $comicPublishedDate,
                            in: dateClosedRange,
                            displayedComponents: .date // Sets DatePicker to pick a date
                        ){
                            Text("Pick Date")
                        }
                    }
                    Section(header: Text("Selected Comic Published Date")) {
                         
                        // Format dateAndTime under the dateFormatter and convert it to String
                        Text(formattedDate(date: comicPublishedDate))
                    }
                }
                else
                {
                    Section(header: Text(comicSearchCategories[selectedComicCategoryIndex])) {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                            
                            // Button to clear the text field
                            Button(action: {
                                searchFieldValue = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                            
                        }   // End of HStack
                    }
                }
                
                Section(header: Text("Search Database")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchDB()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Search query cannot be empty!\nEntered yearBuilt must be integer!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                        Spacer()
                        
                    }   // End of HStack
                }
                if searchCompleted {
                    Section(header: Text("Comic Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Comics Found")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                    Section(header: Text("Clear")) {
                        HStack {
                            Spacer()
                            Button("Clear") {
                                searchCompleted = false
                                searchFieldValue = ""
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            
                            Spacer()
                        }
                    }
                }
                
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle("Search Database")
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
     ---------------------
     MARK: Search Database
     ---------------------
     */
    func searchDB() {
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
                
        comicSearchCategory = comicSearchCategories[selectedComicCategoryIndex]
        
        searchQuery = queryTrimmed
        
        // Public function conductDatabaseSearch is given in DatabaseSearch.swift
        conductComicDatabaseSearch()
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        
        // Global array databaseSearchResults is given in DatabaseSearch.swift
        if comicDatabaseSearchResults.isEmpty {
            return AnyView(
                NotFound(message: "Database Search Produced No Results!\n\nThe database did not return any value for the given search query!")
            )
        }
        
        return AnyView(ComicSearchResultsList())
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        if(selectedComicCategoryIndex == 0)
        {
            searchFieldValue = formattedDate(date: comicPublishedDate)
        }
        let queryTrimmed = searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed.isEmpty {
            return false
        }
        
        return true
    }
    
}

// Helper extensions and views
extension SearchComics {
    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M-d-yyyy"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    SearchComics()
}
