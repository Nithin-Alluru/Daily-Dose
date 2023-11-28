//
//  ComicAPIData.swift
//  DailyDose
//
//  Created by Nithin VT on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

// Global variable to contain the API search results
var ComicsList = [ComicStruct]()

fileprivate var previousQuery = ""

/*
 ================================================
 |   Fetch and Process JSON Data from the API   |
 |   for Recipes for the Given API Search URL   |
 ================================================
*/
public func getComicsFromApi() {
    
    // Initialize the global variable to contain the API search results
    ComicsList = [ComicStruct]()
    
    /*
    ************************************
    *   Yelp Fusion API HTTP Headers   *
    ************************************
    */
    let comicsHeader = [
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "xkcd.com"
    ]
    
    let apiUrlString = "https://xkcd.com/info.0.json"
    
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
         {"month": "11", 
         "num": 2859,
         "link": "",
         "year": "2023",
         "news": "",
         "safe_title":
         "Oceanography Gift",
         "transcript": "",
         "alt": "Shipping times vary. Same-ocean delivery may only take a few years, but delivery from the Weddell Sea in Antarctica may take multiple decades, and molecules meant for inland seas like the Mediterranean may be returned as undeliverable by surface currents.", 
         "img": "https://imgs.xkcd.com/comics/oceanography_gift.png",
         "title": "Oceanography Gift",
         "day": "24"}
         
         let month: String
         let num: Int
         let year: String
         let safe_title: String
         let transcript: String
         let img: String             //the URL
         let day: String

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
        // Get Comic safe_title
        //--------------
        var title = ""
        if let comic_title = topLevelDictionary["title"] as? String {
            title = comic_title
        }
        //--------------
        // Get Comic transcript
        //--------------
        var transcript = ""
        if let comic_det = topLevelDictionary["transcript"] as? String {
            transcript = comic_det
        }
        //--------------
        // Get Comic image
        //--------------
        var img = ""
        if let com = topLevelDictionary["img"] as? String {
            img = com
        }
        //--------------
        // Get Comic alt
        //--------------
        var alt = ""
        if let description = topLevelDictionary["alt"] as? String {
            alt = description
        }
        //--------------
        // Get Comic year
        //--------------
        var year = ""
        if let comic_year = topLevelDictionary["year"] as? String {
            year = comic_year
        }
        //--------------
        // Get Comic month
        //--------------
        var month = ""
        if let comic_month = topLevelDictionary["month"] as? String {
            month = comic_month
        }
        //--------------
        // Get Comic day
        //--------------
        var day = ""
        if let comic_day = topLevelDictionary["day"] as? String {
            day = comic_day
        }
        
        let date = "\(month)-\(day)-\(year)"
        //------------------------------------------------------------------------
        // Create an Instance of BusinessStruct and Append it to foundBusinessesList
        //------------------------------------------------------------------------
        let foundComic = ComicStruct(date: date, safe_title: title, transcript: transcript, img: img, alt: alt)
        
        ComicsList.append(foundComic)
    } catch {
        // foundBusinessList will be empty
        return
    }
}

