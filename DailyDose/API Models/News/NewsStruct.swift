//
//  NewsStruct.swift
//  DailyDose
//
//  Created by Caleb Kong on 11/22/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//
// From News API

import SwiftUI

struct NewsStruct: Decodable {
    let name: String
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}
/*
{"source":
    {"id":"bbc-news","name":"BBC News"},
    "author":"BBC News",
    "title":"Video shows car mauled by a trapped bear",
    "description":"Wildlife officials in Colorado say the animal likely entered the vehicle searching for food.",
    "url":"http://www.bbc.co.uk/news/world-us-canada-67459289",
    "urlToImage":"https://ichef.bbci.co.uk/news/1024/branded_news/361C/production/_131725831_p0gv18t6.jpg",
    "publishedAt":"2023-11-21T20:07:25.1648899Z",
    "content":"'Oh my God, a bear!' Woman gets surprise visitor. Video, 00:00:37'Oh my God, a bear!' Woman gets surprise visitor"},
 */
