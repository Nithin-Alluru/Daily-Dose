//
//  ContentView.swift
//  DailyDose
//
//  Created by CM360 on 11/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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
            FavComicsList()
                .tabItem {
                    Label("Favorite Comics", systemImage: "bookmark.fill")
                }
            Memes()
                .tabItem {
                    Label("Memes", systemImage: "bookmark.fill")
                }
            FavMemesList()
                .tabItem {
                    Label("Favorite Memes", systemImage: "bookmark.fill")
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
