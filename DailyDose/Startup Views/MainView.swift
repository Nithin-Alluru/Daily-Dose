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
    var body: some View {
        TabView {
            NewsPage()
                .tabItem {
                    Label("Feed", systemImage: "newspaper.fill")
                }
            WeatherPage()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.bolt.fill")
                }
            DailyComic()
            .tabItem {
                Label("Today's Comic", systemImage: "book.pages.fill")
            }
            Memes()
                .tabItem {
                    Label("Memes", systemImage: "book.pages.fill")
                }
            FavComicsList()
                .tabItem {
                    Label("Favorite Comics", systemImage: "bookmark.fill")
                }
            FavMemesList()
                .tabItem {
                    Label("Favorite Memes", systemImage: "bookmark.fill")
                }
            Settings()
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
