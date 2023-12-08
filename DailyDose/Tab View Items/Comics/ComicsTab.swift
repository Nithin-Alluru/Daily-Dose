//
//  ComicsTab.swift
//  DailyDose
//
//  Created by Nithin VT on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct ComicsTab: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showAlertMessage = false
    @State private var searchCompleted = false

    @State private var showFavorites = false

    var body: some View {
        NavigationStack {
            ScrollView {
                if searchApi() {
                    let comic = ComicsList[0]

                    VStack(alignment: .leading, spacing: 16) {
                        let imgUrl = comic.img

                        ZStack(alignment: .bottomTrailing) {
                            getImageFromUrl(url: imgUrl, defaultFilename: "ImageUnavailable")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 2))
                                .shadow(radius: 5)  // Add a subtle shadow to the image
<<<<<<< Updated upstream
                                // Long press the comic image to display the context menu
=======
                                // Long press the meme image to display the context menu
>>>>>>> Stashed changes
                                .contextMenu {
                                    // Context Menu Item
                                    Button(action: {
                                        // Copy the image to universal clipboard for pasting elsewhere
                                        UIPasteboard.general.image = getUIImageFromUrl(url: imgUrl, defaultFilename: "ImageUnavailable")

                                        showAlertMessage = true
                                        alertTitle = "Comic Image is Copied to Clipboard"
                                        alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                                    }) {
                                        Image(systemName: "doc.on.doc")
                                        Text("Copy Image")
                                    }
                                }

                            Button(action: {
                                let newComic = Comic(date: comic.date, safe_title: comic.safe_title, transcript: comic.transcript, img: comic.img, alt: comic.alt)
                                modelContext.insert(newComic)

                                showAlertMessage = true
                                alertTitle = "Comic Added!"
                                alertMessage = "Today's Comic is added to the database as a favorite."
                            }) {
                                Image(systemName: "heart.fill")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)  // Add a subtle shadow to the heart button
                            }
                            .padding(8)
                        }

                        if comic.transcript != "" {
                            Text("Transcript:")
<<<<<<< Updated upstream
                                .font(.headline.weight(.bold))
=======
                                .font(.headline)
>>>>>>> Stashed changes
                                .foregroundColor(.white)
                            Text(comic.transcript)
                                .foregroundColor(.white)
                        }

                        Text("Description:")
<<<<<<< Updated upstream
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
=======
                            .font(.headline)
                            .foregroundColor(.white) // Change the color to blue for better visibility
>>>>>>> Stashed changes
                        Text(comic.alt)
                            .foregroundColor(.white)
                
                    }
                    .padding()
                } else {
                    Text("No Comic Today")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("Comic Of The Day")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        getComicsFromApi()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showFavorites.toggle()
                    }) {
                        Image(systemName: "bookmark")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showFavorites) {
                        FavComicsList()
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

    func searchApi() -> Bool {
        getComicsFromApi()
        return !ComicsList.isEmpty
    }
}

#Preview {
    ComicsTab()
}


