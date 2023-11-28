//
//  Favorite Comics.swift
//  DailyDose
//
//  Created by Nithin VT on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import SwiftData
 
struct FavComicsList: View {
   
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Comic>(sortBy: [SortDescriptor(\Comic.safe_title, order: .forward)])) private var listOfAllComicsInDatabase: [Comic]
   
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
   
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfAllComicsInDatabase) { aComic in
                    NavigationLink(destination: ComicDetails(comic: aComic)) {
                        ComicItem(comic: aComic)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to permanently delete the comic?"),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                     'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                      element to be deleted. It is nil if the array is empty. Process it as an optional.
                                     */
                                     if let index = toBeDeleted?.first {
                                         let comicToDelete = listOfAllComicsInDatabase[index]
                                         modelContext.delete(comicToDelete)
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
            .navigationTitle("Favorite Comics")
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
     ----------------------------
     MARK: Delete Selected Recipe
     ----------------------------
     */
    func delete(at offsets: IndexSet) {
       
        toBeDeleted = offsets
        showConfirmation = true
    }
   
}   // End of struct
