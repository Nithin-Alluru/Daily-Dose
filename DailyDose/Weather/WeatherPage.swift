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

fileprivate let weatherRefreshInterval: Double = 3*60   // in seconds

struct WeatherPage: View {

    @State private var weatherInfo: WeatherCollectionStruct?

    @State private var timer = Timer.publish(every: weatherRefreshInterval, on: .main, in: .common).autoconnect()

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
                        if let weather = weatherInfo {
                            CurrentWeatherView(
                                currentTemp: weather.current.temperature,
                                description: "Sunny",
                                lowTemp: 70,
                                highTemp: 80,
                                city: "CityName",
                                state: "AA",
                                scale: .Fahrenheit
                            )

                        } else {
                            Text("Loading...")
                        }
                    }
                    .onReceive(timer) { _ in
                        refreshForecastData()
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
            }   // End of ZStack
        }   // End of NavigationStack
        .onAppear() {
            startTimer()
            if weatherInfo == nil {
                refreshForecastData()
            }
        }
        .onDisappear() {
            stopTimer()
        }
    }   // End of body var
    
    func refreshForecastData() {
        // Wrap API call in a Task to avoid blocking
        Task {
            let currentLocation = getUsersCurrentLocation()
            if let newWeather = fetchWeather(
                latitude: currentLocation.latitude,
                longitude: currentLocation.longitude)
            {
                weatherInfo = newWeather
            }
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: weatherRefreshInterval, on: .main, in: .common).autoconnect()
    }

    func stopTimer() {
        timer.upstream.connect().cancel()
    }

}

struct CurrentWeatherView: View {

    let currentTemp: Double
    let description: String
    let lowTemp: Double
    let highTemp: Double
    let city: String
    let state: String

    let scale: TemperatureScale

    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 80))
                    VStack(alignment: .leading) {
                        Text("\(round(convertKelvinTemp(kelvin: currentTemp, scale: scale)))°")
                        Text("\(description)")
                    }
                    .font(.system(size: 24))
                }
                HStack {
                    Image(systemName: "arrow.down")
                    Text("\(round(convertKelvinTemp(kelvin: lowTemp, scale: scale)))° ")
                    Image(systemName: "arrow.up")
                    Text("\(round(convertKelvinTemp(kelvin: highTemp, scale: scale)))°")
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
