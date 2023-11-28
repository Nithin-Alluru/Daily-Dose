//
//  ComicItem.swift
//  DailyDose
//
//  Created by Nithin VT on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct ComicItem: View {
    let comic: Comic
    var body: some View {
        HStack {
            getImageFromUrl(url: comic.img, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)

            VStack(alignment: .leading) {
                Text(comic.safe_title)
                Text("Published Date : \(comic.date)")
            }
            .font(.system(size: 14))
            
        }   // End of HStack
    }
}
