//
//  HourlyForecastItem.swift
//  DailyDose
//
//  Created by CM360 on 11/28/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct HourlyForecastItem: View {

    // Declare a static formatter to avoid recreating it each time
    // https://docs.swift.org/swift-book/documentation/the-swift-programming-language/properties/#Type-Property-Syntax
    static let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter
    }()

    let forecast: WeatherStruct
    let scale: TemperatureScale
    var now = false

    // The icons and VStack itself have fixed sizes to be more visually appealing
    var body: some View {
        VStack(spacing: 4) {
            if now {
                Text("Now")
                    .font(.body.smallCaps())
            } else {
                Text("\(formatTimeStamp(timestamp: forecast.timestamp))")
                    .font(.body.smallCaps())
            }
            Image(systemName: weatherIcons[forecast.weather[0].icon] ?? "questionmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            Text("\(Int(convertKelvinTemp(kelvin: forecast.temp.current, scale: scale).rounded()))°")
        }
        .frame(width: 50)
    }

    func formatTimeStamp(timestamp: Int) -> String {
        return HourlyForecastItem.timestampFormatter.string(from: Date(timeIntervalSince1970: Double(timestamp)));
    }

}
