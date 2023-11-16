//
//  Newscatcher.swift
//  FinalProject
//
//  Created by Caleb Kong on 11/15/23.
//

import SwiftUI

struct Newscatcher: Decodable {
    let title: String
    let author: String
    let published_date: String
    let link: String
    let clean_url: String
    let excerpt: String
    let summary: String
    let topic: String
    let country: String
    let media: String
}

/*
 "status": "ok",
 "total_hits": 10000,
 "page": 1,
 "total_pages": 200,
 "page_size": 50,
 "articles": [
 "title": "Fantastis, Elon Musk Rogoh Kocek Rp 29,3 Triliun Kembangkan Roket Space di 2023",
 "author": "LIPUTAN6"
 "published_date": "2023-05-01 22:01:00",
 "published_date_precision": "timezone unknown",
 "link": "https://headtopics.com/id/fantastis-elon-musk-rogoh-kocek-rp-29-3-triliun-kembangkan-rc
 "clean_url": "headtopics.com"
 "excerpt": "Elon Musk : Space akan mengeluarkan dana USD 2 miliar untuk pengembangan roket pese
 "summary": "Elon Musk : Space akan mengeluarkan dana USD 2 miliar untuk pengembangan roket pese
 "rights": "headtopics.com"
 "rank": 25702,
 "topic": "news"
 "country": "US",
 "lanquage": "id"
 "authors": "LIPUTAN6",
 "media": "https://i.headtopics.com/images/2023/5/1/liputan6dotcom/fantastis-elon-musk-rogoh-koce
 "is_opinion": false,
 "twitter_account": "headtopicscom",
 */
