//
//  ContentView.swift
//  DailyDose
//
//  Created by CM360 on 11/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @EnvironmentObject var displayedArticles: ArticleList

    var body: some View {
        TabView {
            NewsPage()
                .tabItem {
                    Label("Feed", systemImage: "newspaper.fill")
                }
                .environmentObject(displayedArticles)
            WeatherPage()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.bolt.fill")
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
