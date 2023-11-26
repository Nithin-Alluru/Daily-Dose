//
//  WeatherConversions.swift
//  DailyDose
//
//  Created by CM360 on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

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
