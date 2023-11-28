//
//  MemesStruct.swift
//  DailyDose
//
//  Created by Nithin VT on 11/26/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct MemeStruct: Decodable {
    let memeUrl: String
    let title: String
    let author: String
    let subreddit: String
}

/*
 {
   "postLink": "https://redd.it/jiovfz",
   "subreddit": "dankmemes",
   "title": "*leaves call*",
   "url": "https://i.redd.it/f7ibqp1dmiv51.gif",
   "nsfw": false,
   "spoiler": false,
   "author": "Spartan-Yeet",
   "ups": 3363,

   // preview images of the meme sorted from lowest to highest quality
   "preview": [
     "https://preview.redd.it/f7ibqp1dmiv51.gif?width=108&crop=smart&format=png8&s=02b12609100c14f55c31fe046f413a9415804d62",
     "https://preview.redd.it/f7ibqp1dmiv51.gif?width=216&crop=smart&format=png8&s=8da35457641a045e88e42a25eca64c14a6759f82",
     "https://preview.redd.it/f7ibqp1dmiv51.gif?width=320&crop=smart&format=png8&s=f2250b007b8252c7063b8580c2aa72c5741766ae",
     "https://preview.redd.it/f7ibqp1dmiv51.gif?width=640&crop=smart&format=png8&s=6cd99df5e58c976bc115bd080a1e6afdbd0d71e7"
   ]
 }
 */
