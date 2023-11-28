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

// Fetches current weather and forecast information from the OpenWeather API
// https://openweathermap.org/current
func fetchCurrentWeather(latitude: Double, longitude: Double) -> CurrentWeatherStruct? {

    let apiUrlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(getWeatherApiKey())"

    print(apiUrlString)

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

        print("\(weatherJsonObject)")

        return parseCurrentWeather(data: weatherJsonObject)
    } catch {
        return nil
    }
}

func parseCurrentWeather(data: [String: Any]) -> CurrentWeatherStruct? {
    if let coordJson = data["coord"] as? [String: Any],
       let latitude = coordJson["lat"] as? Double,
       let longitude = coordJson["lon"] as? Double,
       let locationName = data["name"] as? String,
       let timestamp = data["dt"] as? Int,
       let timezone = data["timezone"] as? Int,
       let weatherJson = data["weather"] as? [Any],
       let tempJson = data["main"] as? [String: Any],
       let temp = parseTemperatureDetails(data: tempJson),
       let windJson = data["wind"] as? [String: Any],
       let wind = parseWindDetails(data: windJson),
       let extra = parseExtraDetails(data: data)
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
        return CurrentWeatherStruct(
            latitude: latitude,
            longitude: longitude,
            locationName: locationName,
            timestamp: timestamp,
            timezone: timezone,
            weather: parseWeatherArrays(arrays: weatherJson),
            temp: temp,
            wind: wind,
            rain: rain,
            snow: snow,
            extra: extra
        )
    }
    print("failed current")
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
    print("failed weather")
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
    print("failed temp")
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
    print("failed wind")
    return nil
}

func parsePrecipitationDetails(data: [String: Any]) -> PrecipitationDetailsStruct? {
    return PrecipitationDetailsStruct(
        volume1h: data["1h"] as? Double,
        volume3h: data["3h"] as? Double
    )
}

func parseExtraDetails(data: [String: Any]) -> ExtraDetailsStruct? {
    if let cloudsJson = data["clouds"] as? [String: Any],
       let clouds = cloudsJson["all"] as? Int,
       let mainJson = data["main"] as? [String: Any],
       let humidity = mainJson["humidity"] as? Int,
       let pressure = mainJson["pressure"] as? Int,
       let visibility = data["visibility"] as? Int,
       let sysJson = data["sys"] as? [String: Any],
       let sunrise = sysJson["sunrise"] as? Int,
       let sunset = sysJson["sunset"] as? Int
    {
        return ExtraDetailsStruct(
            clouds: clouds,
            humidity: humidity,
            visibility: visibility,
            pressure: pressure,
            pressureSea: mainJson["sea_level"] as? Int,
            pressureGround: mainJson["grnd_level"] as? Int,
            sunrise: sunrise,
            sunset: sunset
        )
    }
    print("failed extra")
    return nil
}
