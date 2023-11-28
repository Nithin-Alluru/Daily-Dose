//
//  WeatherTab.swift
//  DailyDose
//
//  Created by Aaron Gomez on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

// For converting OpenWeather icon codes to SF Symbol names
// https://openweathermap.org/weather-conditions
let weatherIcons = [
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

struct WeatherTab: View {

    @State private var temperatureScale = TemperatureScale.Fahrenheit

    // Has at least one fetch attempt completed yet?
    @State private var weatherFetchCompleted = false
    @State private var forecastFetchCompleted = false
    // Currently displayed weather information
    @State private var weatherInfo: WeatherStruct?
    @State private var forecastInfo: ForecastStruct?

    @State private var timer = Timer.publish(every: weatherRefreshInterval, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Current Location")) {
                    if let info = weatherInfo {
                        CurrentWeatherView(
                            weather: info,
                            scale: temperatureScale
                        )
                    } else {
                        if weatherFetchCompleted {
                            Text("Unavailable")
                        } else {
                            ProgressView()
                        }
                    }
                }
                .onReceive(timer) { _ in
                    refreshWeatherData()
                }
                Section(header: Text("Today's forecast")) {
                    if let info = forecastInfo {
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                ForEach(info.forecasts, id: \.timestamp) { forecast in
                                    HourlyForecastItem(
                                        forecast: forecast,
                                        scale: temperatureScale
                                    )
                                }
                            }
                        }
                    } else {
                        if forecastFetchCompleted {
                            Text("Unavailable")
                        } else {
                            ProgressView()
                        }
                    }
                }
            }   // End of Form
            // Forms are scrollable, so we can hide the background color to let our
            // dynamic background show through
            .scrollContentBackground(.hidden)
            .background {
                DynamicWeatherBackground()
                    .edgesIgnoringSafeArea(.all)
            }
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
                refreshWeatherData()
            }
        }
        .onDisappear() {
            stopTimer()
        }
    }   // End of body var

    func refreshWeatherData() {
        // Wrap API call in Tasks to avoid blocking
        Task {
            let currentLocation = getUsersCurrentLocation()
            if let newInfo = fetchCurrentWeather(
                latitude: currentLocation.latitude,
                longitude: currentLocation.longitude
            ) {
                weatherInfo = newInfo
            }
            weatherFetchCompleted = true
        }
        Task {
            let currentLocation = getUsersCurrentLocation()
            if let newInfo = fetchForecasts(
                latitude: currentLocation.latitude,
                longitude: currentLocation.longitude
            ) {
                forecastInfo = newInfo
            }
            forecastFetchCompleted = true
        }
    }

    func refreshForecastData() {
    }

    func startTimer() {
        timer = Timer.publish(every: weatherRefreshInterval, on: .main, in: .common).autoconnect()
    }

    func stopTimer() {
        timer.upstream.connect().cancel()
    }

}

struct CurrentWeatherView: View {

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

#Preview {
    WeatherTab()
}
