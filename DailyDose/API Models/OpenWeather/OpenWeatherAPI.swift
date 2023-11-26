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
// https://openweathermap.org/api/one-call-3
func fetchWeather(latitude: Double, longitude: Double) -> WeatherCollectionStruct? {

    // Use the OpenWeather One Call API 3.0's current weather and forecast endpoint
    let apiUrlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(getWeatherApiKey())"

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

    print("\(jsonDataFetchedFromApi)")

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

        //-----------------------------
        // Process location information
        //-----------------------------

        var weatherLocation: WeatherLocationStruct

        weatherLocation = WeatherLocationStruct(
            latitude: latitude,
            longitude: longitude,
            timezoneName: "",
            timezoneOffset: 0
        )

        //--------------------------------
        // Process each wrapper JSON array
        //--------------------------------

        if let currentWeatherJson = weatherJsonObject["current"] as? [String: Any],
           let currentWeather = parseCurrentWeather(data: currentWeatherJson),
           let minutelyForecastsJson = weatherJsonObject["minutely"] as? [[String: Any]],
           let minutelyForecasts = parseMinutelyForecasts(data: minutelyForecastsJson),
           let hourlyForecastsJson = weatherJsonObject["hourly"] as? [[String: Any]],
           let hourlyForecasts = parseHourlyForecasts(data: hourlyForecastsJson),
           let dailyForecastsJson = weatherJsonObject["daily"] as? [[String: Any]],
           let dailyForecasts = parseDailyForecasts(data: dailyForecastsJson),
           let weatherAlertsJson = weatherJsonObject["alerts"] as? [[String: Any]],
           let weatherAlerts = parseWeatherAlerts(data: weatherAlertsJson)
        {
            return WeatherCollectionStruct(
                location: weatherLocation,
                current: currentWeather,
                minutely: minutelyForecasts,
                hourly: hourlyForecasts,
                daily: dailyForecasts,
                alerts: weatherAlerts
            )
        }
    } catch {
        return nil
    }

    return nil
}

func parseWeatherDetails(data: [String: Any]) -> WeatherDetailsStruct? {
    if let pressure = data["pressure"] as? Int,
       let humidity = data["humidity"] as? Int,
       let dewPoint = data["dew_point"] as? Double,
       let uvIndex = data["uvi"] as? Int,
       let clouds = data["clouds"] as? Int,
       let windSpeed = data["wind_speed"] as? Double,
       let windAngle = data["wind_deg"] as? Int,
       let weatherInfo = data["weather"] as? [String: Any],
       let weatherId = weatherInfo["id"] as? Int,
       let weatherDescription = weatherInfo["description"] as? String
    {
        return WeatherDetailsStruct(
            pressure: pressure,
            humidity: humidity,
            dewPoint: dewPoint,
            uvIndex: uvIndex,
            clouds: clouds,
            visibility: data["visibility"] as? Int,
            windSpeed: windSpeed,
            windAngle: windAngle,
            windGust: data["wind_gust"] as? Double,
            weatherId: weatherId,
            weather: weatherDescription
        )
    }
    return nil
}

func parseCurrentWeather(data: [String: Any]) -> CurrentWeatherStruct? {
    if let timestamp = data["dt"] as? Int,
       let sunrise = data["sunrise"] as? Int,
       let sunset = data["sunset"] as? Int,
       let temperature = data["temp"] as? Double,
       let feelsLike = data["feels_like"] as? Double,
       let details = parseWeatherDetails(data: data)
    {
        return CurrentWeatherStruct(
            timestamp: timestamp,
            sunrise: sunrise,
            sunset: sunset,
            temperature: temperature,
            feelsLike: feelsLike,
            details: details
        )
    }
    return nil
}

func parseMinutelyForecasts(data: [[String: Any]]) -> [MinutelyForecastStruct]? {
    var forecasts = [MinutelyForecastStruct]()
    for forecast in data {
        if let timestamp = forecast["dt"] as? Int,
           let precipitation = forecast["precipitation"] as? Double
        {
            forecasts.append(MinutelyForecastStruct(
                timestamp: timestamp,
                precipitation: precipitation
            ))
        } else {
            return nil
        }
    }
    return forecasts
}

func parseHourlyForecasts(data: [[String: Any]]) -> [HourlyForecastStruct]? {
    var forecasts = [HourlyForecastStruct]()
    for forecast in data {
        if let timestamp = forecast["dt"] as? Int,
           let temperature = forecast["temp"] as? Double,
           let feelsLike = forecast["feels_like"] as? Double,
           let details = parseWeatherDetails(data: forecast),
           let precipitation = forecast["pop"] as? Double
        {
            forecasts.append(HourlyForecastStruct(
                timestamp: timestamp,
                temperature: temperature,
                feelsLike: feelsLike,
                details: details,
                precipitation: precipitation
            ))
        } else {
            return nil
        }
    }
    return forecasts
}

func parseDailyForecasts(data: [[String: Any]]) -> [DailyForecastStruct]? {
    var forecasts = [DailyForecastStruct]()
    for forecast in data {
        if let timestamp = forecast["dt"] as? Int,
           let sunrise = forecast["sunrise"] as? Int,
           let sunset = forecast["sunset"] as? Int,
           let moonrise = forecast["moonrise"] as? Int,
           let moonset = forecast["moonset"] as? Int,
           let moonPhase = forecast["moon_phase"] as? Double,
           let summary = forecast["summary"] as? String,
           let tempData = forecast["temp"] as? [String: Any],
           let minTemp = tempData["min"] as? Double,
           let maxTemp = tempData["max"] as? Double,
           let dayTemp = tempData["day"] as? Double,
           let nightTemp = tempData["night"] as? Double,
           let morningTemp = tempData["morn"] as? Double,
           let eveningTemp = tempData["eve"] as? Double,
           let feelsData = forecast["feels_like"] as? [String: Any],
           let dayFeel = feelsData["day"] as? Double,
           let nightFeel = feelsData["night"] as? Double,
           let morningFeel = feelsData["morn"] as? Double,
           let eveningFeel = feelsData["eve"] as? Double,
           let details = parseWeatherDetails(data: forecast),
           let precipitation = forecast["pop"] as? Double
        {
            forecasts.append(DailyForecastStruct(
                timestamp: timestamp,
                sunrise: sunrise,
                sunset: sunset,
                moonrise: moonrise,
                moonset: moonset,
                moonPhase: moonPhase,
                summary: summary,
                minTemp: minTemp,
                maxTemp: maxTemp,
                dayTemp: dayTemp,
                nightTemp: nightTemp,
                morningTemp: morningTemp,
                eveningTemp: eveningTemp,
                dayFeel: dayFeel,
                nightFeel: nightFeel,
                morningFeel: morningFeel,
                eveningFeel: eveningFeel,
                details: details,
                precipitation: precipitation
            ))
        } else {
            return nil
        }
    }
    return forecasts
}

func parseWeatherAlerts(data: [[String: Any]]) -> [WeatherAlertStruct]? {
    var alerts = [WeatherAlertStruct]()
    for alert in data {
        if let sender = alert["sender_name"] as? String,
           let title = alert["event"] as? String,
           let start = alert["start"] as? Int,
           let end = alert["end"] as? Int,
           let description = alert["description"] as? String
        {
            alerts.append(WeatherAlertStruct(
                sender: sender,
                start: start,
                end: end,
                title: title,
                description: description
            ))
        } else {
            return nil
        }
    }
    return alerts
}
