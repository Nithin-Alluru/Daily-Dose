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
    @State private var trending = true
    @State private var showAlertMessage = false

    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @State var runOnce = false

    // For bookmarks sheet
    @EnvironmentObject private var bookmarkedArticles: BookmarksList
    @State private var showingBookmarks = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray.opacity(0.1)
                VStack {
                    Group {
                        /*MARK: Search Bar + Filter*/
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            //.disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .padding(.leading)
                            if showFilters {
                                Button("", systemImage: "slider.horizontal.3") {
                                    showFilters = false
                                }
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .padding()
                            }
                            else {
                                Button("", systemImage: "slider.horizontal.3") {
                                    showFilters = true
                                }
                                .imageScale(.large)
                                .padding()
                            }
                        } //END SEARCH BAR + FILTERS
                        /*MARK: Filters*/
                        if showFilters {
                            HStack {
                                Text("Specify News Source") //Search by Source
                                TextField("Enter a News Source", text: $sourceFieldValue)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.never)
                                    .padding(.leading)
                            }
                            .padding(.horizontal)
                            Toggle("Only Trending Searches", isOn: $trending)
                                .padding(.horizontal)

                        } //END FILTERS
                        Button("Go") {
                            if (!trending && sourceFieldValue.isEmpty && searchFieldValue.isEmpty) {
                                showAlertMessage = true
                                alertTitle = "Missing Input Data!"
                                alertMessage = "Please enter a source or a search query!"

                            } else {
                                displayedArticles.clear()
                                displayedArticles.getNewsArticlesFromApi(trending: trending, source: sourceFieldValue, query: searchFieldValue)
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    TabView {
                        ForEach(displayedArticles.get(), id:\.title) {
                            n in NavigationLink(destination: ArticleDetails(thisArticle: n)) {
                                Article(thisArticle: n)
                            }
                        }
                    } //end TabView
                    .tabViewStyle(PageTabViewStyle())
                    .onAppear() {
                        UIPageControl.appearance().currentPageIndicatorTintColor = .black
                        UIPageControl.appearance().pageIndicatorTintColor = .gray
                        if !runOnce {
                            print("Hello".localizedStandardContains(""))
                            getListOfArticles()
                            runOnce = true
                        }
                    }

                } //End VStack
            }
            .toolbarTitleDisplayMode(.inline)
            //.toolbarBackground(Color.green, for: .navigationBar, .tabBar)
            .navigationTitle("News")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        displayedArticles.clear()
                        displayedArticles.getNewsArticlesFromApi(trending: true, source: "", query: "")
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
            }//END TOOLBAR
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })



        }
    }

    private func getListOfArticles() { //-> [NewsStruct]
        if !runOnce {
            displayedArticles.getNewsArticlesFromApi(trending: true, source: "", query: "")
        }
        return //displayedArticles.get()
    }
}
