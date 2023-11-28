//
//  MemeDetails.swift
//  DailyDose
//
//  Created by Nithin VT on 11/27/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct MemeDetails: View {
    let meme: Meme
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    var body: some View {
        return AnyView(
            Form {
                Section(header: Text("MEME TITLE")) {
                    Text(meme.title)
                }
                Section(header: Text("MEME IMAGE")) {
                    getImageFromUrl(url: meme.memeUrl, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 320, alignment: .leading)
                        .contextMenu {
                            // Context Menu Item
                            Button(action: {
                                // Copy the apartment photo to universal clipboard for pasting elsewhere
                                let imageUrlComponents = meme.memeUrl.components(separatedBy: "/")
                                let imageUrlFilename = imageUrlComponents.last ?? ""
                                UIPasteboard.general.image = UIImage(named: "\(imageUrlFilename).jpg")
                                
                                showAlertMessage = true
                                alertTitle = "Meme is Copied to Clipboard"
                                alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                            }) {
                                Image(systemName: "doc.on.doc")
                                Text("Meme Image")
                            }
                        }
                }
                Section(header: Text("MEME AUTHOR")) {
                    Text(meme.author)
                }
                Section(header: Text("Meme Source Subreddit")) {
                    Text(meme.subreddit)
                }
            } // End of form
        )
    }
}
