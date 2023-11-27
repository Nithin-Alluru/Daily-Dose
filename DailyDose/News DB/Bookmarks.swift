//
//  Bookmarks.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/26/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//
// Referenced:
//  FavoritesList.swift
//  Companies
//
//  Created by Osman Balci on 10/14/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI
import SwiftData

struct Bookmarks: View {
    
    //@EnvironmentObject private var bookmarkedArticles: BookmarksList


    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<News>(sortBy: [SortDescriptor(\News.publishedAt, order: .forward)])) private var listOfAllBookmarksInDatabase: [News]
    
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    @State private var searchBarField = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfAllBookmarksInDatabase) { article in
                    NavigationLink(destination: BookmarkDetails(thisArticle: article)) {
                        BookmarkedArticle(article: article)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to remove this article from your Bookmarks?"),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                    'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                     element to be deleted. It is nil if the array is empty. Process it as an optional.
                                    */
                                    if let index = toBeDeleted?.first {
                                        let articleToDelete = listOfAllBookmarksInDatabase[index]
                                        modelContext.delete(articleToDelete)
                                    }
                                    toBeDeleted = nil
                                }, secondaryButton: .cancel() {
                                    toBeDeleted = nil
                                }
                            )
                        }   // End of alert
                    }
                }
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("Bookmarks")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                // Place the Edit button on left side of the toolbar
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }   // End of toolbar
            
        }   // End of NavigationStack
    }   // End of body var
    
    /*
     -----------------------------
     MARK: Delete Selected Company
     -----------------------------
     */
    func delete(at offsets: IndexSet) {
        
         toBeDeleted = offsets
         showConfirmation = true
     }
    
}   // End of struct



