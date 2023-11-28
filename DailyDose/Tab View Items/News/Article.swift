//
//  Article.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/22/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct Article: View {
    let thisArticle: News
    
    //var containerWidth:CGFloat = UIScreen.main.bounds.width - 32.0
    var body: some View {
        
        ZStack { // Article Element Outer Container
//            Color.red
            
            ZStack { //Article Element inner container
//                Color.yellow
                VStack {
                    getImageFromUrl(url: thisArticle.urlToImage, defaultFilename: "NULL")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                    VStack(alignment: .leading) {
                        Text(thisArticle.title)
                            .font(.system(size: 20))
                        HStack {
                            Image(systemName: "person.circle")
                            Text(thisArticle.author)
                        }
                    }
                    Spacer()
                }
            } //END inner container
            .padding()
            
        } //End outer container
        .padding()
    }
}
