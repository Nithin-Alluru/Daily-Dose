//
//  WeatherConversions.swift
//  DailyDose
//
//  Created by CM360 on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

let compassDirections = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]

enum TemperatureScale {
    case Celcius
    case Fahrenheit
}

// https://en.wikipedia.org/wiki/Conversion_of_scales_of_temperature
func convertKelvinTemp(kelvin: Double, scale: TemperatureScale) -> Double {
    switch (scale) {
    case .Celcius:
        return kelvin - 273.15
    case .Fahrenheit:
        return kelvin * 9/5 - 459.67
    }
}

func compassDirection(angle: Double) -> String {
    let index = Int((angle + 11.25) / 22.5) % 16
    return compassDirections[index]
}
