//
//  MemesTab.swift
//  DailyDose
//
//  Created by Nithin VT on 11/26/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct MemesTab: View {
    @Environment(\.modelContext) private var modelContext

    // Alert Message
    @State private var showAlertMessage = false
    @State private var searchCompleted = false
    @State private var meme: MemeStruct? = nil // Assuming Meme is the type of the meme object
    var body: some View {
        
        NavigationStack {
            Form {
                if let meme = meme {
                    Section(header: Text("Here's Your Meme")) {
                        let imgUrl = meme.memeUrl
                        getImageFromUrl(url: imgUrl, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 400, alignment: .leading)
                    }
                    Button("Generate Next Meme") {
                        // Handle button tap action here
                        // You can call a function to fetch the next meme or perform any other action
                        getMeme()
                    }
                    .foregroundColor(.blue)
                    Section(header: Text("ADD MEME TO FAVORITES")) {
                        Button(action: {
                            let newMeme = Meme(memeUrl: meme.memeUrl, title: meme.title, author: meme.author, subreddit: meme.subreddit)
                            // Insert the new Book object into the database
                            modelContext.insert(newMeme)
                            
                            showAlertMessage = true
                            alertTitle = "Meme Added!"
                            alertMessage = "Meme is added to database as a favorite."
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Add Meme to Favorites")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                } else {
                    Button("Generate Meme") {
                        // Handle button tap action here
                        // You can call a function to fetch the next meme or perform any other action
                        getMeme()
                    }
                }
            }
            .font(.system(size: 14))
            .navigationTitle(Text("Daily Memes"))
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        }
    }

    func getMeme() {
        getMemesFromApi()
        if MemesList.isEmpty {
            showAlertMessage = true
        } else {
            meme = MemesList[0]
        }
    }
}
