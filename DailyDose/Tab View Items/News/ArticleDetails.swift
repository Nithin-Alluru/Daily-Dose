//
//  ArticleDetails.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/23/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct ArticleDetails: View {
    let thisArticle: NewsStruct

    @State var bookmarked: Bool = false
    @Environment(\.modelContext) private var modelContext
    @State private var showAlertMessage = false


    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(minHeight: 20)
                Group {
                    Text(thisArticle.title)
                        .font(.custom("Helvetica Neue Condensed Bold", size: 24))
                        .font(.largeTitle)
                        .padding(.horizontal, 10)
                    getImageFromUrl(url: thisArticle.urlToImage, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                HStack() {
                    VStack(alignment: .leading) {
                        Text(thisArticle.name)
                            .font(.system(size: 20))
                            .fontWeight(.heavy)
                        HStack {
                            Image(systemName: "person.circle")
                            if (thisArticle.author.isEmpty) {
                                Text("Not Found")
                                    .font(.caption)
                            } else {
                                Text(thisArticle.author)
                                    .font(.caption)
                            }
                        }
                        HStack {
                            Image(systemName: "calendar")
                            Text(getTime(time: thisArticle.publishedAt))
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 10)
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                Spacer()
                    .frame(minHeight: 20)
                Group {
                    Text(thisArticle.content)
                        .padding(.horizontal, 10)
                }
                Link(destination: URL(string: thisArticle.url)!) {
                    HStack {
                        Image(systemName: "globe")
                            .imageScale(.small)
                            .font(Font.title.weight(.regular))
                        Text("Visit Original Article To Contiue Reading")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.blue)
                }
                .padding()

            } // End VSTACK
            .toolbar {
                ToolbarItem(id: "bookmark") {
                    if !bookmarked {
                        Button("Bookmark This Article", systemImage: "bookmark") {
                            bookmarked = true

                            alertTitle = "News Article Bookmarked!"
                            alertMessage = "You can find this article later in the bookmarks menu."
                            showAlertMessage = true
                        }
                    }
                    else {
                        Button("Unookmark This Article", systemImage: "bookmark.fill") {
                            bookmarked = false

                            alertTitle = "Article Removed from Bookmarks"
                            alertMessage = "This article been removed from your bookmarks."
                            showAlertMessage = true
                        }
                    }
                }
            } //END TOOLBAR
        } //END SCROLL VIEW
        .onDisappear() {
            if bookmarked {
                let newArticle = News(name: thisArticle.name, author: thisArticle.author, title: thisArticle.title, description: thisArticle.description, url: thisArticle.url, urlToImage: thisArticle.urlToImage, publishedAt: thisArticle.publishedAt, content: thisArticle.content)
                modelContext.insert(newArticle)
            }
        }
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(alertMessage)
        })
    } //END BODY

}

private func getTime(time: String) -> String {
    /* 2023-11-21T20:07:23.007296Z */
    let formatter = ISO8601DateFormatter()
    // Insert .withFractionalSeconds to the current format.
    formatter.formatOptions.insert(.withFractionalSeconds)
    let date = (formatter.date(from: time) ?? Date()) as Date
    return date.formatted(date: .complete, time: .complete)
}


private func isBookmarked(thisArticle: NewsStruct) {
    let newArticle = News(name: thisArticle.name, author: thisArticle.author, title: thisArticle.title, description: thisArticle.description, url: thisArticle.url, urlToImage: thisArticle.urlToImage, publishedAt: thisArticle.publishedAt, content: thisArticle.content)

}

