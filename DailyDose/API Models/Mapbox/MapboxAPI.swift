//
//  MapboxAPI.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/6/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

fileprivate let apiHeaders = [
    "accept": "application/json",
    "cache-control": "no-cache",
    "connection": "keep-alive",
    "host": "api.mapbox.com"
]

let sessionToken = "00000000-0000-0000-0000-000000000000"

// MARK: API Fetch Functions

func queryUnresolvedCities(query: String) -> [UnresolvedCityStruct]? {
    var apiUrlString = "https://api.mapbox.com/search/searchbox/v1/suggest?q=\(query)&access_token=\(mapboxAPIKey)&session_token=\(sessionToken)&types=city&proximity="

    // Determine proximity mode based on location availability
    let usersLocation = getUsersCurrentLocation()
    if usersLocation.latitude == 0 && usersLocation.longitude == 0 {
        apiUrlString += "ip"
    } else {
        apiUrlString += "\(usersLocation.longitude),\(usersLocation.latitude)"
    }

    /*
    ************************************
    *   Fetch JSON Data from the API   *
    ************************************
    */
    var jsonDataFromApi: Data

    let jsonDataFetchedFromApi = getJsonDataFromApi(
        apiHeaders: apiHeaders,
        apiUrl: apiUrlString,
        timeout: 10.0
    )

    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return nil
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
        let jsonResponse = try JSONSerialization.jsonObject(
            with: jsonDataFromApi,
            options: JSONSerialization.ReadingOptions.mutableContainers
        )

        /*
         JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
         Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
         where Dictionary Key type is String and Value type is Any (instance of any type)
         */

        //-----------------------------
        // Obtain Top Level JSON Object
        //-----------------------------

        var citiesJsonObject = [String: Any]()

        if let jsonObject = jsonResponse as? [String: Any] {
            citiesJsonObject = jsonObject
        } else {
            return nil
        }

        //----------------------------
        // Obtain Top Level JSON Array
        //----------------------------

        var citiesJsonArray = [Any]()

        if let jsonArray = citiesJsonObject["suggestions"] as? [Any] {
            citiesJsonArray = jsonArray
        } else {
            return nil
        }

        print(citiesJsonArray)

        return parseUnresolvedCities(array: citiesJsonArray)
    } catch {
        return nil
    }
}

func fetchResolvedCity(city: UnresolvedCityStruct) -> City? {
    let apiUrlString = "https://api.mapbox.com/search/searchbox/v1/retrieve/\(city.mapboxId)?access_token=\(mapboxAPIKey)&session_token=\(sessionToken)"

    /*
    ************************************
    *   Fetch JSON Data from the API   *
    ************************************
    */
    var jsonDataFromApi: Data

    let jsonDataFetchedFromApi = getJsonDataFromApi(
        apiHeaders: apiHeaders,
        apiUrl: apiUrlString,
        timeout: 10.0
    )

    if let jsonData = jsonDataFetchedFromApi {
        jsonDataFromApi = jsonData
    } else {
        return nil
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
        let jsonResponse = try JSONSerialization.jsonObject(
            with: jsonDataFromApi,
            options: JSONSerialization.ReadingOptions.mutableContainers
        )

        /*
         JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
         Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
         where Dictionary Key type is String and Value type is Any (instance of any type)
         */

        //-----------------------------
        // Obtain Top Level JSON Object
        //-----------------------------

        var citiesJsonObject = [String: Any]()

        if let jsonObject = jsonResponse as? [String: Any] {
            citiesJsonObject = jsonObject
        } else {
            return nil
        }

        //----------------------------
        // Obtain Top Level JSON Array
        //----------------------------

        var citiesJsonArray = [Any]()

        if let jsonArray = citiesJsonObject["features"] as? [Any] {
            citiesJsonArray = jsonArray
        } else {
            return nil
        }

        return parseResolvedCity(array: citiesJsonArray)
    } catch {
        return nil
    }
}

// MARK: API Response Parsers

func parseUnresolvedCities(array: [Any]) -> [UnresolvedCityStruct] {
    var cityResults = [UnresolvedCityStruct]()
    for cityObject in array {
        if let cityJson = cityObject as? [String: Any],
           let newCity = parseUnresolvedCity(data: cityJson)
        {
            cityResults.append(newCity)
        }
    }
    return cityResults
}

func parseUnresolvedCity(data: [String: Any]) -> UnresolvedCityStruct? {
    if let mapboxId = data["mapbox_id"] as? String,
       let name = data["name"] as? String,
       let contextJson = data["context"] as? [String: Any],
       let regionJson = contextJson["region"] as? [String: Any],
       let regionName = regionJson["name"] as? String
    {
        return UnresolvedCityStruct(mapboxId: mapboxId, name: name, regionName: regionName)
    }
    return nil
}

func parseResolvedCity(array: [Any]) -> City? {
    if let featureJson = array[0] as? [String: Any],
       let propsJson = featureJson["properties"] as? [String: Any],
       let name = propsJson["name"] as? String,
       let contextJson = propsJson["context"] as? [String: Any],
       let regionJson = contextJson["region"] as? [String: Any],
       let regionName = regionJson["name"] as? String,
       let coordsJson = propsJson["coordinates"] as? [String: Any],
       let latitude = coordsJson["latitude"] as? Double,
       let longitude = coordsJson["longitude"] as? Double
    {
        return City(
            name: name,
            regionName: regionName,
            latitude: latitude,
            longitude: longitude
        )
    }
    return nil
}
