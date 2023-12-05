//
//  DatabaseSearch.swift
//  Landmarks
//
//  Created by Nithin VT on 11/30/23.
//  Copyright © 2023 Nithin Alluru. All rights reserved.
//

import SwiftUI
import SwiftData

// Global variable to hold database search results
var comicDatabaseSearchResults = [Comic]()

// Global Search Parameters
var comicSearchCategory = ""
var searchQuery = ""

public func conductComicDatabaseSearch() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage Company, Location, and SocialMedia objects
        modelContainer = try ModelContainer(for: Comic.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context (workspace) where database objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    // Initialize the global variable to hold the database search results
    comicDatabaseSearchResults = [Comic]()
    
    switch comicSearchCategory {
    case "Comic Title":
        // 1️⃣ Define the Search Criterion (Predicate)
        let titlePredicate = #Predicate<Comic> {
            $0.safe_title.localizedStandardContains(searchQuery)
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let titleFetchDescriptor = FetchDescriptor<Comic>(
            predicate: titlePredicate,
            sortBy: [SortDescriptor(\Comic.safe_title, order: .forward)]
        )
        
        // 3️⃣ Execute the Fetch Request
        do {
            comicDatabaseSearchResults = try modelContext.fetch(titleFetchDescriptor)
        } catch {
            fatalError("Unable to fetch comic title data from the database")
        }
        
    case "Comic Published Date":
        // 1️⃣ Define the Search Criterion (Predicate)
        let datePredicate = #Predicate<Comic> {
            $0.date.localizedStandardContains(searchQuery)
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let dateFetchDescriptor = FetchDescriptor<Comic>(
            predicate: datePredicate,
            sortBy: [SortDescriptor(\Comic.safe_title, order: .forward)]
        )
        
        // 3️⃣ Execute the Fetch Request
        do {
            comicDatabaseSearchResults = try modelContext.fetch(dateFetchDescriptor)
        } catch {
            fatalError("Unable to fetch landmark location data from the database")
        }

    case "Comic Transcript":
        // 1️⃣ Define the Search Criterion (Predicate)
        let transcriptPredicate = #Predicate<Comic> {
            $0.transcript.localizedStandardContains(searchQuery)
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let transcriptFetchDescriptor = FetchDescriptor<Comic>(
            predicate: transcriptPredicate,
            sortBy: [SortDescriptor(\Comic.safe_title, order: .forward)]
        )
        
        // 3️⃣ Execute the Fetch Request
        do {
            comicDatabaseSearchResults = try modelContext.fetch(transcriptFetchDescriptor)
        } catch {
            fatalError("Unable to fetch landmark description data from the database")
        }
    case "Comic Alternate Description":
        // 1️⃣ Define the Search Criterion (Predicate)
        let altPredicate = #Predicate<Comic> {
            $0.alt.localizedStandardContains(searchQuery)
        }
        
        // 2️⃣ Define the Fetch Descriptor
        let altFetchDescriptor = FetchDescriptor<Comic>(
            predicate: altPredicate,
            sortBy: [SortDescriptor(\Comic.safe_title, order: .forward)]
        )
        
        // 3️⃣ Execute the Fetch Request
        do {
            comicDatabaseSearchResults = try modelContext.fetch(altFetchDescriptor)
        } catch {
            fatalError("Unable to fetch landmark description data from the database")
        }
        
    default:
        fatalError("Search category is out of range!")
    }
    
    // Sort search results w.r.t. comic name
    comicDatabaseSearchResults.sort(by: { $0.safe_title < $1.safe_title })
}
