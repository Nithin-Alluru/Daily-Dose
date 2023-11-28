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
    //--------------
    // Alert Message
    //--------------
    @State private var showAlertMessage = false
    @State private var searchCompleted = false
    var body: some View {
        NavigationStack {
            Form {
                if(searchApi())
                {
                    let comic = ComicsList[0]
                    Section(header: Text("\(comic.safe_title)")) {
                        let imgUrl = comic.img
                        getImageFromUrl(url: imgUrl, defaultFilename: "ImageUnavailable")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 400, alignment: .leading)
                            .contextMenu {
                                // Context Menu Item
                                Button(action: {
                                    // Copy the apartment photo to universal clipboard for pasting elsewhere
                                    let imageUrlComponents = imgUrl.components(separatedBy: "/")
                                    let imageUrlFilename = imageUrlComponents.last ?? ""
                                    UIPasteboard.general.image = UIImage(named: "\(imageUrlFilename).jpg")
                                    
                                    showAlertMessage = true
                                    alertTitle = "Comic is Copied to Clipboard"
                                    alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                                }) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy Image")
                                }
                            }
                    }
                    if(comic.transcript != "")
                    {
                        Section(header: Text("Transcript")) {
                            Text(comic.transcript)
                        }
                    }
                    Section(header: Text("ALTERNATE DESCRIPTION")) {
                        Text(comic.alt)
                    }
                    Section(header: Text("ADD COMIC TO FAVORITES")) {
                        Button(action: {
                            let newComic = Comic(date: comic.date, safe_title: comic.safe_title, transcript: comic.transcript, img: comic.img, alt: comic.alt)
                            // Insert the new Book object into the database
                            modelContext.insert(newComic)
                            
                            showAlertMessage = true
                            alertTitle = "Comic Added!"
                            alertMessage = "Today's Comic is added to database as a favorite."
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("Add Comic to Favorites")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                else
                {
                    Text("No Comic Today")
                }
            } // End of Form
            .font(.system(size: 14))
            .background(
                    Image("ComicBackground")
                        .resizable()
                )
            .navigationTitle(Text("Comic Of The Day"))
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
        } // End of NavigationStack
    } // End of Body var
    /*
     ----------------
     MARK: Search API
     ----------------
     */
    func searchApi() -> Bool{
        getComicsFromApi()
        if(ComicsList.isEmpty) {
            return false
        }
        else
        {
            return true
        }
    }
}

#Preview {
    ComicsTab()
}

