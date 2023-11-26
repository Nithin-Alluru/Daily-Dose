//
//  OpenWeatherAPI.swift
//  DailyDose
//
//  Created by Aaron Gomez on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

var currentWeatherInfo: ForecastCollection?

public func fetchForecastsForLocation(latitude: Double, longitude: Double) {
    let apiUrlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(getWeatherApiKey())"
}
