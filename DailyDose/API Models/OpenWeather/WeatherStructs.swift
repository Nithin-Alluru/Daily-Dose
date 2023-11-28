//
//  WeatherStructs.swift
//  DailyDose
//
//  Created by Aaron Gomez on 11/15/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

struct WeatherStruct {

    let locationName: String?

    let timestamp: Int  // in Unix epoch time

    let weather: [WeatherDetailsStruct]
    let temp: TemperatureDetailsStruct
    let wind: WindDetailsStruct?

    // Volumes in last 1h/3h
    let rain: PrecipitationDetailsStruct?
    let snow: PrecipitationDetailsStruct?

    let extra: ExtraDetailsStruct

}

struct WeatherDetailsStruct {

    // https://openweathermap.org/weather-conditions
    let id: Int
    let group: String
    let description: String
    let icon: String

}

struct TemperatureDetailsStruct {

    // All values in Kelvin
    let current: Double
    let feelsLike: Double
    let low: Double
    let high: Double

}

struct WindDetailsStruct {

    let speed: Double   // in meters/second
    let direction: Int  // direction in degrees
    let gust: Double?   // in meters/second

}

struct PrecipitationDetailsStruct {

    let volume1h: Double?   // in mm
    let volume3h: Double?   // in mm

}

struct ExtraDetailsStruct {

    let clouds: Int?            // % out of 100
    let humidity: Int?          // % out of 100
    let visibility: Int?        // in meters <= 10,000

    let pressure: Int?          // in hPa
    let pressureSea: Int?       // in hPa
    let pressureGround: Int?    // in hPa

    let sunrise: Int?           // in Unix epoch time
    let sunset: Int?            // in Unix epoch time

}

//  Current weather JSON format API response example
//{
//    "coord": {
//        "lon": 10.99,
//        "lat": 44.34
//    },
//    "weather": [
//        {
//            "id": 501,
//            "main": "Rain",
//            "description": "moderate rain",
//            "icon": "10d"
//        }
//    ],
//    "base": "stations",
//    "main": {
//        "temp": 298.48,
//        "feels_like": 298.74,
//        "temp_min": 297.56,
//        "temp_max": 300.05,
//        "pressure": 1015,
//        "humidity": 64,
//        "sea_level": 1015,
//        "grnd_level": 933
//    },
//    "visibility": 10000,
//    "wind": {
//        "speed": 0.62,
//        "deg": 349,
//        "gust": 1.18
//    },
//    "rain": {
//        "1h": 3.16
//    },
//    "clouds": {
//        "all": 100
//    },
//    "dt": 1661870592,
//    "sys": {
//        "type": 2,
//        "id": 2075663,
//        "country": "IT",
//        "sunrise": 1661834187,
//        "sunset": 1661882248
//    },
//    "timezone": 7200,
//    "id": 3163858,
//    "name": "Zocca",
//    "cod": 200
//}

struct ForecastStruct {
    let forecasts: [WeatherStruct]
}
