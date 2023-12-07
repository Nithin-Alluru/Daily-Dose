//
//  Article.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/22/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct Article: View {
    let thisArticle: NewsStruct

    var body: some View {
        VStack {
            getImageFromUrl(url: thisArticle.urlToImage, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
            Text(thisArticle.title)
                .font(.custom("Helvetica Neue Condensed Bold", size: 24))
                .font(.largeTitle)
            Spacer()
        }
        .padding()
        .background(Color("BackgroundColor"))
        .padding()
        .shadow(radius: 5)  // Add a subtle shadow
    }
}
