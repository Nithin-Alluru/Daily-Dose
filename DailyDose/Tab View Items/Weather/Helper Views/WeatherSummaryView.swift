//
//  WeatherSummaryView.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/6/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct WeatherSummaryView: View {

    let weather: WeatherStruct
    let scale: TemperatureScale

    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Image(systemName: weatherIcons[weather.weather[0].icon] ?? "questionmark")
                        .font(.system(size: 80))
                    VStack(alignment: .leading) {
                        Text("\(Int(convertKelvinTemp(kelvin: weather.temp.current, scale: scale).rounded()))°")
                        Text(weather.weather[0].group)
                    }
                    .font(.system(size: 24))
                }
                HStack {
                    Image(systemName: "arrow.down")
                    Text("\(Int(convertKelvinTemp(kelvin: weather.temp.low, scale: scale).rounded()))° ")
                    Image(systemName: "arrow.up")
                    Text("\(Int(convertKelvinTemp(kelvin: weather.temp.high, scale: scale).rounded()))°")
                }
                if let location = weather.locationName {
                    Text(location)
                }
            }
            Spacer()
        }
    }

}
