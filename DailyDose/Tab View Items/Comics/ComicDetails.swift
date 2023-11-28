//
//  ComicDetails.swift
//  DailyDose
//
//  Created by Nithin VT on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct ComicDetails: View {
    let comic: Comic
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        return AnyView(
            Form {
                Section(header: Text("COMIC TITLE")) {
                    Text(comic.safe_title)
                }
                Section(header: Text("COMIC IMAGE")) {
                    getImageFromUrl(url: comic.img, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 320, alignment: .leading)
                        .contextMenu {
                            // Context Menu Item
                            Button(action: {
                                // Copy the apartment photo to universal clipboard for pasting elsewhere
                                let imageUrlComponents = comic.img.components(separatedBy: "/")
                                let imageUrlFilename = imageUrlComponents.last ?? ""
                                UIPasteboard.general.image = UIImage(named: "\(imageUrlFilename).jpg")
                                
                                showAlertMessage = true
                                alertTitle = "Comic Image is Copied to Clipboard"
                                alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                            }) {
                                Image(systemName: "doc.on.doc")
                                Text("Copy Image")
                            }
                        }
                }
                if(!comic.transcript.isEmpty)
                {
                    Section(header: Text("COMIC TRANSCRIPT")) {
                        Text(comic.transcript)
                    }
                }
                Section(header: Text("ALTERNATE DESCRIPTION")) {
                    Text(comic.alt)
                }
                Section(header: Text("COMIC PUBLISHED DATE")) {
                    Text(comic.date)
                }
            } // End of form
        )
    }
}
