//
//  FavoriteMemes.swift
//  DailyDose
//
//  Created by Nithin VT on 11/27/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import SwiftData
 
struct FavMemesList: View {
   
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Meme>(sortBy: [SortDescriptor(\Meme.title, order: .forward)])) private var listOfAllMemesInDatabase: [Meme]
   
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
   
    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfAllMemesInDatabase) { aMeme in
                    NavigationLink(destination: MemeDetails(meme: aMeme)) {
                        MemeItem(meme: aMeme)
                            .alert(isPresented: $showConfirmation) {
                                Alert(title: Text("Delete Confirmation"),
                                      message: Text("Are you sure to permanently delete the meme?"),
                                      primaryButton: .destructive(Text("Delete")) {
                                    /*
                                     'toBeDeleted (IndexSet).first' is an unsafe pointer to the index number of the array
                                      element to be deleted. It is nil if the array is empty. Process it as an optional.
                                     */
                                     if let index = toBeDeleted?.first {
                                         let memeToDelete = listOfAllMemesInDatabase[index]
                                         modelContext.delete(memeToDelete)
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
            .navigationTitle("Favorite Memes")
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
