//
//  ArticleList.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

/*
 Used for news Feed
 */
public class ArticleList: ObservableObject {

    @Published var articles = [NewsStruct]()

    /*
     Add an article to the list
     */
    func add(article: NewsStruct) {
        articles.append(article)
    }

    /*
     Get the size
     */
    func getSize() -> Int {
        return articles.count
    }

    /*
     Clear the array of articles
     */
    func clear() {
        articles.removeAll()
    }

    func get() -> [NewsStruct] {
        return articles
    }

    func queryApiAndPopulate(trending: Bool, source: String, query: String) {
        self.clear()
        if let newArticles = getNewsArticlesFromApi(
            trending: trending,
            source: source,
            query: query
        ) {
            self.articles = newArticles
        }
    }
}
