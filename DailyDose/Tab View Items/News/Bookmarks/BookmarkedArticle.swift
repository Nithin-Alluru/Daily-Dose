//
//  BookmarkedArticle.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/27/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//
// Referenced:
//  FavoriteItem.swift
//  Companies
//
//  Created by Osman Balci on 10/14/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import SwiftUI

struct BookmarkedArticle: View {

    // Input Parameter
    let article: News

    var body: some View {
        HStack {
            getImageFromUrl(url: article.urlToImage, defaultFilename: "Null")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100.0)

            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.system(size: 14))
                Text(article._description)
                    .font(.caption)
            }
        }
    }
}
