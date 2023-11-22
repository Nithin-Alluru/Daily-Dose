//
//  DatabaseClasses.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/22/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import SwiftData

@Model
final class News {
    let name: String
    let author: String
    let title: String
    let _description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    init(name: String, author: String, title: String, description: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        self.name = name
        self.author = author
        self.title = title
        self._description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}
