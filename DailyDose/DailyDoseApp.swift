//
//  DailyDoseApp.swift
//  DailyDose
//
//  Created by CS3714 Team 2 on 11/16/23.
//

import SwiftUI
import SwiftData

@main
struct DailyDoseApp: App {

    @StateObject var displayedArticles = ArticleList()
    @StateObject var bookmarkedArticles = BookmarksList()

    init() {
        // In DatabaseCreation.swift
//        init_db()
        // Ask user for location permission
        getPermissionForLocation()
    }

    @AppStorage("darkMode") private var darkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                // Change the color mode of the entire app to Dark or Light
                .preferredColorScheme(darkMode ? .dark : .light)
                .environmentObject(displayedArticles)
                .environmentObject(bookmarkedArticles)
                .modelContainer(for: [News.self, Comic.self, Meme.self], isUndoEnabled: true)
        }
    }
}
