//
//  NewsPage.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/22/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//
// Referenced:
//  Photos.swift
//  Cars
//
//  Created by Caleb Kong on 9/18/23.
//

import SwiftUI
import SwiftData


struct NewsTab: View {

    @EnvironmentObject private var displayedArticles: ArticleList

    @State private var showFilters = false
    @State private var searchFieldValue = ""

    @State private var sourceFieldValue = ""
    @State private var showTrendingOnly = true
    @State private var showAlertMessage = false

    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @State var runOnce = false

    // For bookmarks sheet
    @EnvironmentObject private var bookmarkedArticles: BookmarksList
    @State private var showingBookmarks = false

    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    // MARK: Search Bar + Filter
                    HStack {
                        TextField("Enter a search query", text: $searchFieldValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .padding(.leading)
                        Button("", systemImage: "slider.horizontal.3") {
                            showFilters.toggle()
                        }
                        .imageScale(.large)
                        .fontWeight(showFilters ? .bold : .regular)
                        .padding()
                    } // END SEARCH BAR + FILTERS
                    // MARK: Filters
                    if showFilters {
                        Group {
                            HStack {
                                Text("From:") //Search by Source
                                TextField("Enter a news source name.", text: $sourceFieldValue)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .padding(.leading)
                            }
                            Toggle("Only trending articles", isOn: $showTrendingOnly)
                        }
                        .padding(.horizontal)
                    } // End filters
                    Button("Go") {
                        if (!showTrendingOnly && sourceFieldValue.isEmpty && searchFieldValue.isEmpty) {
                            showAlertMessage = true
                            alertTitle = "Missing Input Data!"
                            alertMessage = "Please enter a source or a search query!"
                        } else {
                            displayedArticles.queryApiAndPopulate(
                                trending: showTrendingOnly,
                                source: sourceFieldValue,
                                query: searchFieldValue
                            )
                        }
                    }
                    .buttonStyle(.bordered)
                }
                TabView {
                    ForEach(displayedArticles.get(), id:\.title) { n in
                        NavigationLink(destination: ArticleDetails(thisArticle: n)) {
                            Article(thisArticle: n)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } // End of TabView
                .tabViewStyle(PageTabViewStyle())
                .onAppear() {
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "ForegroundColor")
                    UIPageControl.appearance().pageIndicatorTintColor = .gray
                    if !runOnce {
                        refreshTrendingArticles()
                        runOnce = true
                    }
                }
            } // End of VStack
            .background(Color.gray.opacity(0.1))
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("News Feed")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        refreshTrendingArticles()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingBookmarks.toggle()
                    }) {
                        Image(systemName: "bookmark")
                    }
                    .sheet(isPresented: $showingBookmarks) {
                        Bookmarks()
                            .environmentObject(bookmarkedArticles)
                    }
                }
            } // End of toolbar
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }
    }

    private func refreshTrendingArticles() {
        Task {
            displayedArticles.queryApiAndPopulate(
                trending: true,
                source: "",
                query: ""
            )
        }
    }

}
