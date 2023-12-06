//
//  DatabaseClasses.swift
//  DailyDose
//
//  Created by Nithin VT on 11/28/23.
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

@Model
final class City {
    let name: String
    let regionName: String
    let latitude: Double
    let longitude: Double

    init(name: String, regionName: String, latitude: Double, longitude: Double) {
        self.name = name
        self.regionName = regionName
        self.latitude = latitude
        self.longitude = longitude
    }
}


@Model
final class Comic {
    let date: String
    let safe_title: String
    let transcript: String
    let img: String             //the URL
    let alt: String
    
    init(date: String, safe_title: String, transcript: String, img: String, alt: String) {
        self.date = date
        self.safe_title = safe_title
        self.transcript = transcript
        self.img = img
        self.alt = alt
    }
}

@Model
final class Meme {
    let memeUrl: String
    let title: String
    let author: String
    let subreddit: String
    
    init(memeUrl: String, title: String, author: String, subreddit: String) {
        self.memeUrl = memeUrl
        self.title = title
        self.author = author
        self.subreddit = subreddit
    }
}
