//
//  MainView.swift
//  PhotosVideos
//
//  Created by Osman Balci on 6/30/23.
//  Created by Nithin VT on 10/17/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI

struct MainView: View {

    @EnvironmentObject var displayedArticles: ArticleList

    var body: some View {
        TabView {
            NewsTab()
                .tabItem {
                    Label("Feed", systemImage: "newspaper.fill")
                }
                .environmentObject(displayedArticles)
            WeatherTab()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.bolt.fill")
                }
            ComicsTab()
                .tabItem {
                    Label("Comics", systemImage: "book.pages.fill")
                }
            MemesTab()
                .tabItem {
                    Label("Memes", systemImage: "photo.fill")
                }
            SearchComics()
                .tabItem {
                    Label("Search Comics", systemImage: "magnifyingglass")
                }
            SudokuView()
                .tabItem {
                    Label("Sudoku", systemImage: "squareshape.split.3x3")
                }
            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .onAppear {
            // Display TabView with opaque background
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

}

#Preview {
    MainView()
}
