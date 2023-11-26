//
//  WeatherPage.swift
//  DailyDose
//
//  Created by Aaron Gomez on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

let sunnyGradient = Gradient(colors: [Color(hex: 0x73b1e6), Color(hex: 0xa5c9e8)])
let rainyGradient = Gradient(colors: [Color(hex: 0x1b3045), Color(hex: 0x8196ab)])

struct WeatherPage: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: sunnyGradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                Form {
                    Section(header: Text("Current Location")) {
                        CurrentWeatherView(
                            currentTemp: 75,
                            description: "Sunny",
                            lowTemp: 70,
                            highTemp: 80,
                            city: "Blacksburg",
                            state: "VA"
                        )
                    }
                    Section(header: Text("Today's forecast")) {
                        Text("Hourly")
                    }
                    Section(header: Text("Weekly forecast")) {
                        Text("Daily")
                    }
                }   // End of Form
                // Forms are scrollable, so we can hide the background color to let our
                // dynamic background show through
                .scrollContentBackground(.hidden)
            }   // End of NavigationStack
        }
    }
}

struct CurrentWeatherView: View {

    let currentTemp: Int
    let description: String
    let lowTemp: Int
    let highTemp: Int
    let city: String
    let state: String

    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 80))
                    VStack(alignment: .leading) {
                        Text("\(currentTemp)°")
                        Text("\(description)")
                    }
                    .font(.system(size: 24))
                }
                HStack {
                    Image(systemName: "arrow.down")
                    Text("\(lowTemp)° ")
                    Image(systemName: "arrow.up")
                    Text("\(highTemp)°")
                }
                Text("\(city), \(state)")
            }
            Spacer()
        }
    }
}

struct HourlyForecastItem: View {
    
    let time: String
    let temperature: Int
    
    var body: some View {
        VStack {
            Text(time)
            Image(systemName: "cloud.fill")
            Text("\(temperature)°")
        }
    }

}

#Preview {
    WeatherPage()
}
