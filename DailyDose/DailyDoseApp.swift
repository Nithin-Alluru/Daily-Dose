//
//  DailyDoseApp.swift
//  DailyDose
//
//  Created by CM360 on 11/16/23.
//

import SwiftUI
import SwiftData

@main
struct DailyDoseApp: App {

    init() {
        // In DatabaseCreation.swift
        init_db()
        // Ask user for location permission
        getPermissionForLocation()
    }

    //@AppStorage("darkMode") private var darkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Change the color mode of the entire app to Dark or Light
                //.preferredColorScheme(darkMode ? .dark : .light)

                .modelContainer(for: [News.self, Comic.self, Meme.self], isUndoEnabled: true)
        }
    }
}
