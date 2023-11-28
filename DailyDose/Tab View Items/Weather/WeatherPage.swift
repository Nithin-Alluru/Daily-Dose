//
//  WeatherPage.swift
//  DailyDose
//
//  Created by Aaron Gomez on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

// For converting OpenWeather icon codes to SF Symbol names
// https://openweathermap.org/weather-conditions
fileprivate let weatherIcons = [
    // clear sky
    "01d": "sun.max.fill",
    "01n": "moon.stars.fill",
    // few clouds
    "02d": "cloud.sun.fill",
    "02n": "cloud.moon.fill",
    // scattered clouds
    "03d": "cloud.fill",
    "03n": "cloud.fill",
    // broken clouds
    "04d": "cloud.fill",
    "04n": "cloud.fill",
    // shower rain
    "09d": "cloud.drizzle.fill",
    "09n": "cloud.drizzle.fill",
    // rain
    "10d": "cloud.rain.fill",
    "10n": "cloud.rain.fill",
    // thunderstorm
    "11d": "cloud.sun.bolt.fill",
    "11n": "cloud.moon.bolt.fill",
    // snow
    "13d": "snowflake",
    "13n": "snowflake",
    // mist
    "50d": "cloud.fog.fill",
    "50n": "cloud.fog.fill",
]

fileprivate let weatherRefreshInterval: Double = 5*60   // in seconds

struct WeatherPage: View {

    @State private var weatherInfo: CurrentWeatherStruct?

    @State private var timer = Timer.publish(every: weatherRefreshInterval, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                DynamicWeatherBackground()
                    .ignoresSafeArea()
                Form {
                    Section(header: Text("Current Location")) {
                        if let info = weatherInfo {
                            CurrentWeatherView(
                                currentTemp: info.temp.current,
                                description: info.weather[0].group,
                                icon: info.weather[0].icon,
                                lowTemp: info.temp.low,
                                highTemp: info.temp.high,
                                location: info.locationName,
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
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Weather")
            .toolbar {
                ToolbarItem(id: "map") {
                    NavigationLink(destination: WeatherMap()) {
                        Image(systemName: "map")
                    }
                }
            }

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
        return;
        // Wrap API call in a Task to avoid blocking
        Task {
            let currentLocation = getUsersCurrentLocation()
            if let newInfo = fetchCurrentWeather(
                latitude: currentLocation.latitude,
                longitude: currentLocation.longitude)
            {
                weatherInfo = newInfo
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
    let icon: String
    let lowTemp: Double
    let highTemp: Double
    let location: String

    let scale: TemperatureScale

    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Image(systemName: weatherIcons[icon] ?? "questionmark")
                        .font(.system(size: 80))
                    VStack(alignment: .leading) {
                        Text("\(Int(convertKelvinTemp(kelvin: currentTemp, scale: scale).rounded()))°")
                        Text(description)
                    }
                    .font(.system(size: 24))
                }
                HStack {
                    Image(systemName: "arrow.down")
                    Text("\(Int(convertKelvinTemp(kelvin: lowTemp, scale: scale).rounded()))° ")
                    Image(systemName: "arrow.up")
                    Text("\(Int(convertKelvinTemp(kelvin: highTemp, scale: scale).rounded()))°")
                }
                Text(location)
            }
            Spacer()
        }
    }

}

#Preview {
    WeatherPage()
}
