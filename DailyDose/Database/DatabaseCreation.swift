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
        modelContainer = try ModelContainer(for: News.self, Comic.self, Meme.self)
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
    
    // Comics
    let ComicsFetchDescriptor = FetchDescriptor<Comic>()
    var listOfAllComicsInDatabase = [Comic]()
    do {
        // Obtain all of the News objects from the database
        listOfAllComicsInDatabase = try modelContext.fetch(ComicsFetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database")
    }
    if !listOfAllComicsInDatabase.isEmpty {
        print("Database has already been created!")
        return
    }
    
    // Pun Memes
    let MemesFetchDescriptor = FetchDescriptor<Meme>()
    var listOfAllMemesInDatabase = [Meme]()
    do {
        // Obtain all of the News objects from the database
        listOfAllMemesInDatabase = try modelContext.fetch(MemesFetchDescriptor)
    } catch {
        fatalError("Unable to fetch data from the database")
    }
    if !listOfAllMemesInDatabase.isEmpty {
        print("Database has already been created!")
        return
    }
    /*
     =================================
     |   Save All Database Changes   |
     =================================
     🔴 NOTE: Database changes are automatically saved and SwiftUI Views are
     automatically refreshed upon State change in the UI or after a certain time period.
     But sometimes, you can manually save the database changes just to be sure.
     */
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }
    
    print("Database is successfully created!")
}
