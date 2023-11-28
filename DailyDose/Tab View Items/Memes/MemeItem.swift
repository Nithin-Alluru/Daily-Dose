//
//  MemeItem.swift
//  DailyDose
//
//  Created by Nithin VT on 11/27/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct MemeItem: View {
    let meme: Meme
    var body: some View {
        HStack {
            getImageFromUrl(url: meme.memeUrl, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)

            VStack(alignment: .leading) {
                Text(meme.title)
                Text("Author: \(meme.author)")
                Text("Subreddit: \(meme.subreddit)")
            }
            .font(.system(size: 14))
            
        }   // End of HStack
    }
}
