//
//  OpenWeatherAPI.swift
//  DailyDose
//
//  Created by Aaron Gomez on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

fileprivate let apiHeaders = [
    "accept": "application/json",
    "cache-control": "no-cache",
    "connection": "keep-alive",
    "host": "api.openweathermap.org"
]

// MARK: Current Weather Information
// Fetches current weather information from the OpenWeather API
// https://openweathermap.org/current
func fetchCurrentWeather(latitude: Double, longitude: Double) -> WeatherStruct? {

    let apiUrlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(openWeatherAPIKey)"

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

        var weatherJsonObject = [String: Any]()

        if let jsonObject = jsonResponse as? [String: Any] {
            weatherJsonObject = jsonObject
        } else {
            return nil
        }

        return parseWeather(data: weatherJsonObject)
    } catch {
        return nil
    }
}

// MARK: Forecast Information
// Fetches forecast information from the OpenWeather API
// https://openweathermap.org/forecast5
func fetchForecasts(latitude: Double, longitude: Double) -> ForecastStruct? {

    let apiUrlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(openWeatherAPIKey)"

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

        var forecastsJsonObject = [String: Any]()

        if let jsonObject = jsonResponse as? [String: Any] {
            forecastsJsonObject = jsonObject
        } else {
            return nil
        }

        //----------------------------
        // Obtain Top Level JSON Array
        //----------------------------

        var forecastsJsonArray = [Any]()

        if let jsonArray = forecastsJsonObject["list"] as? [Any] {
            forecastsJsonArray = jsonArray
        } else {
            return nil
        }

        return parseForecasts(data: forecastsJsonArray)
    } catch {
        return nil
    }
}

func parseWeather(data: [String: Any]) -> WeatherStruct? {
    if let timestamp = data["dt"] as? Int,
       let weatherJson = data["weather"] as? [Any],
       let tempJson = data["main"] as? [String: Any],
       let temp = parseTemperatureDetails(data: tempJson),
       let windJson = data["wind"] as? [String: Any]
    {
        // Rain/snow volumes are optional
        var rain: PrecipitationDetailsStruct?
        var snow: PrecipitationDetailsStruct?
        // Parse optional precipitation data
        if let rainJson = data["rain"] as? [String: Any] {
            rain = parsePrecipitationDetails(data: rainJson)
        }
        if let snowJson = data["snow"] as? [String: Any] {
            snow = parsePrecipitationDetails(data: snowJson)
        }
        // Return parsed weather struct
        return WeatherStruct(
            locationName: data["name"] as? String,
            timestamp: timestamp,
            weather: parseWeatherArrays(arrays: weatherJson),
            temp: temp,
            wind: parseWindDetails(data: windJson),
            rain: rain,
            snow: snow,
            extra: parseExtraDetails(data: data)
        )
    }
    return nil
}

func parseWeatherArrays(arrays: [Any]) -> [WeatherDetailsStruct] {
    var weatherStructs = [WeatherDetailsStruct]()
    for array in arrays {
        if let weatherJson = array as? [String: Any],
           let weatherDetails = parseWeatherDetails(data: weatherJson)
        {
            weatherStructs.append(weatherDetails)
        }
    }
    return weatherStructs
}

func parseWeatherDetails(data: [String: Any]) -> WeatherDetailsStruct? {
    if let id = data["id"] as? Int,
       let group = data["main"] as? String,
       let description = data["description"] as? String,
       let icon = data["icon"] as? String
    {
        return WeatherDetailsStruct(
            id: id,
            group: group,
            description: description,
            icon: icon
        )
    }
    return nil
}

func parseTemperatureDetails(data: [String: Any]) -> TemperatureDetailsStruct? {
    if let current = data["temp"] as? Double,
       let feelsLike = data["feels_like"] as? Double,
       let low = data["temp_min"] as? Double,
       let high = data["temp_max"] as? Double
    {
        return TemperatureDetailsStruct(
            current: current,
            feelsLike: feelsLike,
            low: low,
            high: high
        )
    }
    return nil
}

func parseWindDetails(data: [String: Any]) -> WindDetailsStruct? {
    if let speed = data["speed"] as? Double,
       let direction = data["deg"] as? Int
    {
        return WindDetailsStruct(
            speed: speed,
            direction: direction,
            gust: data["gust"] as? Double   // not always available
        )
    }
    return nil
}

func parsePrecipitationDetails(data: [String: Any]) -> PrecipitationDetailsStruct? {
    return PrecipitationDetailsStruct(
        volume1h: data["1h"] as? Double,
        volume3h: data["3h"] as? Double
    )
}

func parseExtraDetails(data: [String: Any]) -> ExtraDetailsStruct {
    // main
    var humidity: Int?
    var pressure: Int?
    var pressureSea: Int?
    var pressureGround: Int?
    if let mainJson = data["main"] as? [String: Any] {
        if let value = mainJson["humidity"] as? Int {
            humidity = value
        }
        if let value = mainJson["pressure"] as? Int {
            pressure = value
        }
        if let value = mainJson["sea_level"] as? Int {
            pressureSea = value
        }
        if let value = mainJson["grnd_level"] as? Int {
            pressureGround = value
        }
    }
    // clouds
    var clouds: Int?
    if let cloudsJson = data["clouds"] as? [String: Any],
       let value = cloudsJson["all"] as? Int
    {
        clouds = value
    }
    // sys
    var sunrise: Int?
    var sunset: Int?
    if let sysJson = data["sys"] as? [String: Any] {
        if let value = sysJson["sunrise"] as? Int {
            sunrise = value
        }
        if let value = sysJson["sunset"] as? Int {
            sunset = value
        }
    }
    return ExtraDetailsStruct(
        clouds: clouds,
        humidity: humidity,
        visibility: data["visibility"] as? Int,
        pressure: pressure,
        pressureSea: pressureSea,
        pressureGround: pressureGround,
        sunrise: sunrise,
        sunset: sunset
    )
}

func parseForecasts(data: [Any]) -> ForecastStruct? {
    var forecasts = [WeatherStruct]()
    for object in data {
        if let forecastJson = object as? [String: Any],
           let forecast = parseWeather(data: forecastJson)
        {
            forecasts.append(forecast)
        }
    }
    return ForecastStruct(forecasts: forecasts)
}
