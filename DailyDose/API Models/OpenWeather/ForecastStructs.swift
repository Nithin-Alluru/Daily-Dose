//
//  ForecastStructs.swift
//  DailyDose
//
//  Created by Caleb Kong and Aaron Gomez on 11/15/23.
//

import Foundation

struct ForecastCollection {

    let location: ForecastLocation

    let current: CurrentForecastStruct
    let minutely: [MinutelyForecastStruct]
    let hourly: [HourlyForecastStruct]
    let daily: [DailyForecastStruct]

    let alerts: [WeatherAlertStruct]

}

struct ForecastLocation {

    let latitude: Double        // in range (-90,90)
    let longitude: Double       // in range (-180, 180)
    let timezoneName: String    // of form Area/Location
    let timezoneOffset: Int     // in seconds from UTC

}

struct ForecastDetailsStruct {

    let temperature: Double // in Kelvin
    let feelsLike: Double   // in Kelvin
    let pressure: Int       // in hPa
    let humidity: Int       // % out of 100
    let dewPoint: Double    // in Kelvin
    let uvIndex: Double
    let clouds: Int         // % out of 100
    let visibility: Int     // in meters <= 10,000
    let windSpeed: Double   // in meters/second
    let windAngle: Int      // Wind direction in degrees
    let windGust: Double?   // in meters/second

    let weatherId: Int      // https://openweathermap.org/weather-conditions
    let weather: String     // description of weather

}

struct CurrentForecastStruct {

    let timestamp: Int  // in Unix epoch time
    let sunrise: Int    // in Unix epoch time
    let sunset: Int     // in Unix epoch time
    let details: ForecastDetailsStruct

}

struct MinutelyForecastStruct {

    let timestamp: Int          // in Unix epoch time
    let precipitation: Double   // % out of 1

}

struct HourlyForecastStruct {

    let timestamp: Int          // in Unix epoch time
    let details: ForecastDetailsStruct
    let precipitation: Double   // % out of 1

}

struct DailyForecastStruct {

    let timestamp: Int      // in Unix epoch time
    let sunrise: Int        // in Unix epoch time
    let sunset: Int         // in Unix epoch time
    let moonrise: Int       // in Unix epoch time
    let moonset: Int        // in Unix epoch time
    let moonPhase: Double   //
    let summary: String

    let dayTemp: Double     //
    let minTemp: Double     //
    let maxTemp: Double     //
    let nightTemp: Double   //
    let morningTemp: Double //
    let eveningTemp: Double //

    let dayFeel: Double     //
    let nightFeel: Double   //
    let morningFeel: Double //
    let eveningFeel: Double //

    let pressure: Int       // in hPa
    let humidity: Int       // % out of 100
    let dewPoint: Double    // in Kelvin
    let uvIndex: Double
    let clouds: Int         // % out of 100
    let visibility: Int     // in meters <= 10,000
    let windSpeed: Double   // in meters/second
    let windAngle: Int      // Wind direction in degrees
    let windGust: Double?   // in meters/second

    let weatherId: Int      // https://openweathermap.org/weather-conditions
    let weather: String     // description of weather

}

struct WeatherAlertStruct {

    let sender: String
    let start: Int
    let end: Int
    let title: String
    let description: String

}

/*
 {
    "lat":33.44,
    "lon":-94.04,
    "timezone":"America/Chicago",
    "timezone_offset":-18000,
    "current":{
       "dt":1684929490,
       "sunrise":1684926645,
       "sunset":1684977332,
       "temp":292.55,
       "feels_like":292.87,
       "pressure":1014,
       "humidity":89,
       "dew_point":290.69,
       "uvi":0.16,
       "clouds":53,
       "visibility":10000,
       "wind_speed":3.13,
       "wind_deg":93,
       "wind_gust":6.71,
       "weather":[
          {
             "id":803,
             "main":"Clouds",
             "description":"broken clouds",
             "icon":"04d"
          }
       ]
    },
    "minutely":[
       {
          "dt":1684929540,
          "precipitation":0
       },
       ...
    ],
    "hourly":[
       {
          "dt":1684926000,
          "temp":292.01,
          "feels_like":292.33,
          "pressure":1014,
          "humidity":91,
          "dew_point":290.51,
          "uvi":0,
          "clouds":54,
          "visibility":10000,
          "wind_speed":2.58,
          "wind_deg":86,
          "wind_gust":5.88,
          "weather":[
             {
                "id":803,
                "main":"Clouds",
                "description":"broken clouds",
                "icon":"04n"
             }
          ],
          "pop":0.15
       },
       ...
    ],
    "daily":[
       {
          "dt":1684951200,
          "sunrise":1684926645,
          "sunset":1684977332,
          "moonrise":1684941060,
          "moonset":1684905480,
          "moon_phase":0.16,
          "summary":"Expect a day of partly cloudy with rain",
          "temp":{
             "day":299.03,
             "min":290.69,
             "max":300.35,
             "night":291.45,
             "eve":297.51,
             "morn":292.55
          },
          "feels_like":{
             "day":299.21,
             "night":291.37,
             "eve":297.86,
             "morn":292.87
          },
          "pressure":1016,
          "humidity":59,
          "dew_point":290.48,
          "wind_speed":3.98,
          "wind_deg":76,
          "wind_gust":8.92,
          "weather":[
             {
                "id":500,
                "main":"Rain",
                "description":"light rain",
                "icon":"10d"
             }
          ],
          "clouds":92,
          "pop":0.47,
          "rain":0.15,
          "uvi":9.23
       },
       ...
    ],
     "alerts": [
     {
       "sender_name": "NWS Philadelphia - Mount Holly (New Jersey, Delaware, Southeastern Pennsylvania)",
       "event": "Small Craft Advisory",
       "start": 1684952747,
       "end": 1684988747,
       "description": "...SMALL CRAFT ADVISORY REMAINS IN EFFECT FROM 5 PM THIS\nAFTERNOON TO 3 AM EST FRIDAY...\n* WHAT...North winds 15 to 20 kt with gusts up to 25 kt and seas\n3 to 5 ft expected.\n* WHERE...Coastal waters from Little Egg Inlet to Great Egg\nInlet NJ out 20 nm, Coastal waters from Great Egg Inlet to\nCape May NJ out 20 nm and Coastal waters from Manasquan Inlet\nto Little Egg Inlet NJ out 20 nm.\n* WHEN...From 5 PM this afternoon to 3 AM EST Friday.\n* IMPACTS...Conditions will be hazardous to small craft.",
       "tags": [

       ]
     },
     ...
   ]
 */
