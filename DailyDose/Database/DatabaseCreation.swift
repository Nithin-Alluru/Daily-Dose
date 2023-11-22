//
//  DatabaseCreation.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/22/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import SwiftData

public func init_db() {
    var modelContainer: ModelContainer
    do {
        // Create a database container to manage News objects
        modelContainer = try ModelContainer(for: News.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    /*
     MARK: News Struct
     */
    // Create the context (workspace) where News objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    let NewsFetchDescriptor = FetchDescriptor<News>()
    var listOfAllNewsInDatabase = [News]()
    do {
        // Obtain all of the News objects from the database
        listOfAllNewsInDatabase = try modelContext.fetch(NewsFetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database")
    }
    if !listOfAllNewsInDatabase.isEmpty {
        print("Database has already been created!")
        return
    }
    print("Database will be created!")

    var NewsStructList = [NewsStruct]()
    
    // The function is given in UtilityFunctions.swift
    NewsStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "InitialDBContent-News.json", fileLocation: "Main Bundle")
    for n in NewsStructList {
        
        // Instantiate a new News object and dress it up
        let newNews = News(name: n.name, author: n.author, title: n.title, description: n.description, url: n.url, urlToImage: n.urlToImage, publishedAt: n.publishedAt, content: n.content)
        
        // Insert the new News object into the database
        modelContext.insert(newNews)
    }   // End of the for loop
    
}
