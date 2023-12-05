//
//  SearchResultsList.swift
//  Landmarks
//
//  Created by Nithin VT on 11/30/23.
//  Copyright © 2023 Nithin Alluru. All rights reserved.
//

import SwiftUI

struct ComicSearchResultsList: View {
    var body: some View {
        List {
            ForEach(comicDatabaseSearchResults) { aComic in
                NavigationLink(destination: ComicDetails(comic: aComic)) {
                    ComicItem(comic: aComic)
                }
            }
        }
        .navigationTitle("Database Search Results")
        .toolbarTitleDisplayMode(.inline)
    }
}
