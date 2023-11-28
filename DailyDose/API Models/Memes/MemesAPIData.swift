//
//  MemesAPIData.swift
//  DailyDose
//
//  Created by Nithin VT on 11/26/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

// Global variable to contain the API search results
var MemesList = [MemeStruct]()

fileprivate var previousQuery = ""

/*
 ================================================
 |   Fetch and Process JSON Data from the API   |
 |   for Recipes for the Given API Search URL   |
 ================================================
*/
public func getMemesFromApi() {
    
    // Initialize the global variable to contain the API search results
    MemesList = [MemeStruct]()
    
    /*
    ************************************
    *   Yelp Fusion API HTTP Headers   *
    ************************************
    */
    let comicsHeader = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "meme-api.com"
    ]
    
    let apiUrlString = "https://meme-api.com/gimme"
    
    /*
    ***************************************************
    *   Fetch JSON Data from the API Asynchronously   *
    ***************************************************
    */
    var jsonDataFromApi: Data
    
    let jsonDataFetchedFromApi = getJsonDataFromApi(apiHeaders: comicsHeader, apiUrl: apiUrlString, timeout: 10.0)
    
    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return
    }

    /*
    **************************************************
    *   Process the JSON Data Fetched from the API   *
    **************************************************
    */
    do {
        /*
         Foundation framework’s JSONSerialization class is used to convert JSON data
         into Swift data types such as Dictionary, Array, String, Int, Double or Bool.
         */
        let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                               options: JSONSerialization.ReadingOptions.mutableContainers)
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
        
        //----------------------------
        // Obtain Top Level Dictionary
        //----------------------------
        var topLevelDictionary = [String: Any]()
        
        if let jsonObject = jsonResponse as? [String: Any] {
            topLevelDictionary = jsonObject
        } else {
            return
        }
        
        //--------------
        // Get meme url
        //--------------
        var meme = ""
        if let pun_meme = topLevelDictionary["url"] as? String {
            meme = pun_meme
        }
        //--------------
        // Get meme title
        //--------------
        var title = ""
        if let memeTitle = topLevelDictionary["title"] as? String {
            title = memeTitle
        }
        //--------------
        // Get meme author
        //--------------
        var author = ""
        if let memeAuthor = topLevelDictionary["author"] as? String {
            author = memeAuthor
        }
        //--------------
        // Get meme subreddit
        //--------------
        var subreddit = ""
        if let memeSubreddit = topLevelDictionary["subreddit"] as? String {
            subreddit = memeSubreddit
        }
        //------------------------------------------------------------------------
        // Create an Instance of BusinessStruct and Append it to foundBusinessesList
        //------------------------------------------------------------------------
        let randomMeme = MemeStruct(memeUrl: meme, title: title, author: author, subreddit: subreddit)
        
        MemesList.append(randomMeme)
    } catch {
        // foundBusinessList will be empty
        return
    }
}


