//
//  BookmarksList.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/27/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import SwiftData

public class BookmarksList: ObservableObject {

    @Published var displayedBookmarks = [News]()

    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<News>(sortBy: [SortDescriptor(\News.publishedAt, order: .forward)])) private var listOfAllBookmarksInDatabase: [News]

    func remove(articleToDelete: News) {
        modelContext.delete(articleToDelete)
    }

    func add(articleToAdd: News) {
        modelContext.insert(articleToAdd)
    }

    func contains(thisTitle: String, thisAuthor: String, thisPublisher: String) -> Bool {
        //Iterate over the database
        for bookmark in listOfAllBookmarksInDatabase {
            //if we have a match we can break
            if bookmark.title == thisTitle &&
                bookmark.author == thisAuthor &&
                bookmark.name == thisPublisher {
                return true
            }
        }
        //We've seen the entire database so we can say this article is not bookmarked
        return false
    }



    func searchFor(thisQuery: String) -> [News] {
        if thisQuery.isEmpty {
            displayedBookmarks = listOfAllBookmarksInDatabase
            return displayedBookmarks
        }
        var modelContainer: ModelContainer
        do {
            // Create a database container to manage Company, Location, and SocialMedia objects
            modelContainer = try ModelContainer(for: News.self, City.self, Comic.self, Meme.self)
        } catch {
            fatalError("Unable to create ModelContainer")
        }

        // Create the context (workspace) where database objects will be managed
        let localModelContext = ModelContext(modelContainer)

        // Initialize the global variable to hold the database search results
        //databaseSearchResults = [News]()


        let thisPredicate = #Predicate<News> {
            $0.name.localizedStandardContains(thisQuery) ||
            $0.title.localizedStandardContains(thisQuery) ||
            $0.author.localizedStandardContains(thisQuery) ||
            $0._description.localizedStandardContains(thisQuery)
        }

        let thisFetchDescriptor = FetchDescriptor<News>(
            predicate: thisPredicate,
            sortBy: [SortDescriptor(\News.publishedAt, order: .forward)]
        )

        do {
            displayedBookmarks = try localModelContext.fetch(thisFetchDescriptor)
        } catch {
            fatalError("Unable to fetch name data from the database")
        }
        return displayedBookmarks
    }

}
