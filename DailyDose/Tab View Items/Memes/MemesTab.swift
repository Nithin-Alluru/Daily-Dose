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

    @State private var showFavorites = false

    var body: some View {
        NavigationStack {
            ScrollView {
                if let meme = meme {
                    VStack(alignment: .leading, spacing: 16) {
                        getImageFromUrl(url: meme.memeUrl, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 2))
                            .shadow(radius: 5)  // Add a subtle shadow to the image
                        .padding(8)
                        HStack{
                            Button(action: {
                                // Handle button tap action here
                                // You can call a function to fetch the next meme or perform any other action
                                getMeme()
                            }) {
                                Text("Generate Next Meme")
                                    .font(.headline)
                                    .padding()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue)
                                            .shadow(radius: 5)
                                    )
                            }
                            .padding()
                            
                            Button(action: {
                                let newMeme = Meme(memeUrl: meme.memeUrl, title: meme.title, author: meme.author, subreddit: meme.subreddit)
                                // Insert the new Book object into the database
                                modelContext.insert(newMeme)
                                showAlertMessage = true
                                alertTitle = "Meme Added!"
                                alertMessage = "Meme is added to database as a favorite."
                            }) {
                                Image(systemName: "heart.fill")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)  // Add a subtle shadow to the heart button
                            }
                        }
                        .padding(.trailing, 16) // Add spacing to the leading edge of the HStack
                    }
                } else {
                    Button(action: {
                        // Handle button tap action here
                        // You can call a function to fetch the next meme or perform any other action
                        getMeme()
                    }) {
                        Text("Generate Meme")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue)
                                    .shadow(radius: 5)
                            )
                    }
                    .padding()
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("Daily Memes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showFavorites.toggle()
                    }) {
                        Image(systemName: "bookmark")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showFavorites) {
                        FavMemesList()
                    }
                }
            }
            .alert(alertTitle, isPresented: $showAlertMessage) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
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

#Preview {
    MemesTab()
}
