//
//  WeatherTab.swift
//  DailyDose
//
//  Created by Aaron Gomez on 11/25/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import MapKit

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

    // Need to read dark mode preference for overrides
    @AppStorage("darkMode") private var darkMode = false

    @State private var temperatureScale = TemperatureScale.Fahrenheit

    // Has at least one fetch attempt completed yet?
    @State private var weatherFetchCompleted = false
    @State private var forecastFetchCompleted = false
    // Currently displayed weather information
    @State private var weatherInfo: WeatherStruct?
    @State private var forecastInfo: ForecastStruct?

    // Timer to auto-refresh current weather data
    @State private var timer = Timer.publish(every: weatherRefreshInterval, on: .main, in: .common).autoconnect()

    // Currently selected city, or nil for user's location
    @State private var selectedCity: City?
    @State private var showCitySheet = false

    var body: some View {
        NavigationStack {
            Form {
                // Weather summary
                if let info = weatherInfo {
                    Section(header: Group {
                        if let city = selectedCity {
                            Text(city.name)
                        } else {
                            Text("Current Location")
                        }
                    }) {
                        WeatherSummaryView(
                            weather: info,
                            scale: temperatureScale
                        )
                    }
                    .foregroundStyle(.white)
                    .listRowBackground(Rectangle().background(.ultraThinMaterial))
                } else {
                    Section(header: Text("Current Location")) {
                        if weatherFetchCompleted {
                            Text("Unavailable")
                        } else {
                            ProgressView()
                        }
                    }
                }
                // 3h forecasts
                if let info = forecastInfo {
                    Section(header: Text("3h forecasts")) {
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                if let current = weatherInfo {
                                    ForecastItemView(
                                        forecast: current,
                                        scale: temperatureScale,
                                        now: true
                                    )
                                }
                                ForEach(info.forecasts, id: \.timestamp) { forecast in
                                    ForecastItemView(
                                        forecast: forecast,
                                        scale: temperatureScale
                                    )
                                }
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .listRowBackground(Rectangle().background(.ultraThinMaterial))
                } else {
                    Section(header: Text("3h forecasts")) {
                        if forecastFetchCompleted {
                            Text("Unavailable")
                        } else {
                            ProgressView()
                        }
                    }
                }
                // Additional details
                if let info = weatherInfo {
                    // Wind
                    if let wind = info.wind {
                        Section(header: Text("Wind")) {
                            VStack(alignment: .leading) {
                                Text(
                                    String(
                                        format: "%.2fm/s @ %d° (%@)",
                                        wind.speed,
                                        wind.direction,
                                        compassDirection(angle: Double(wind.direction))
                                    )
                                )
                                if let gust = wind.gust {
                                    Text(String(format: "with %.2fm/s gusts", gust))
                                }
                            }
                        }
                        .foregroundStyle(.white)
                        .listRowBackground(Rectangle().background(.ultraThinMaterial))
                    }
                    // Preciptation
                    if info.rain != nil || info.snow != nil {
                        Section(header: Text("Preciptation")) {
                            VStack(alignment: .leading) {
                                if let rain = info.rain {
                                    if let rain1h = rain.volume1h {
                                        Text(String(format: "%.2fmm rain in last 1h", rain1h))
                                    }
                                    if let rain3h = rain.volume3h {
                                        Text(String(format: "%.2fmm rain in last 3h", rain3h))
                                    }
                                }
                                if let snow = info.snow {
                                    if let snow1h = snow.volume1h {
                                        Text(String(format: "%.2fmm snow in last 1h", snow1h))
                                    }
                                    if let snow3h = snow.volume3h {
                                        Text(String(format: "%.2fmm snow in last 3h", snow3h))
                                    }
                                }
                            }
                        }
                        .foregroundStyle(.white)
                        .listRowBackground(Rectangle().background(.ultraThinMaterial))
                    }
                    // Misc.
                    Section(header: Text("Additional Info")) {
                        if let clouds = info.extra.clouds {
                            Text("Cloud cover: \(clouds)%")
                        }
                        if let humidity = info.extra.humidity {
                            Text("Humidity: \(humidity)%")
                        }
                        if let visibility = info.extra.visibility {
                            Text("Visibility: \(visibility)m")
                        }
                        if let pressure = info.extra.pressure {
                            Text("Pressure: \(pressure) hPa")
                        }
                    }
                    .foregroundStyle(.white)
                    .listRowBackground(Rectangle().background(.ultraThinMaterial))
                }
            }   // End of Form
            // Required to both undo the color scheme changes applied to the NavigationStack
            // (see below) and to force a good background color for the sections.
            .environment(\.colorScheme, getFormColorScheme())
            // The refreshable modifier enables the common pull-to-refresh feature
            // https://developer.apple.com/documentation/swiftui/view/refreshable(action:)
            .refreshable {
                refreshAll()
            }
            // Auto-refresh on city change
            .onChange(of: selectedCity) {
                refreshAll()
            }
            // Auto-refresh on timer
            .onReceive(timer) { _ in
                refreshWeatherData()
            }
            // Forms are scrollable, so we can hide the background color to let our
            // dynamic background show through
            .scrollContentBackground(.hidden)
            .background {
                if let currentWeather = weatherInfo {
                    ImmersiveWeatherView(currentWeather: currentWeather.weather[0].icon)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Color.gray.opacity(0.1)
                }
            }
            // Title/toolbar
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("Weather")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showCitySheet.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: WeatherMap()) {
                        Image(systemName: "map")
                    }
                }
            }
            // City selection sheet
            .sheet(isPresented: $showCitySheet) {
                CityList(
                    selectedCity: $selectedCity,
                    showCitySheet: $showCitySheet
                )
            }
        }   // End of NavigationStack
        // Overrides dark mode preference to ensure the navigation title is readable
        // against the dynamic background. Note that neither .preferredColorScheme
        // nor .toolbarColorScheme seem to change the entire style correctly, so
        // .environment is required. (Likely either an iOS bug or an inconsistency
        // during the UIKit -> SwiftUI transition phase)
        .environment(\.colorScheme, getNavColorScheme())
        // Timer control
        .onAppear() {
            startTimer()
            if weatherInfo == nil {
                refreshAll()
            }
        }
        .onDisappear() {
            stopTimer()
        }
    }   // End of body var

    // MARK: Weather/forecast refreshing

    func getSelectedLocation() -> CLLocationCoordinate2D {
        if let city = selectedCity {
            return CLLocationCoordinate2D(
                latitude: city.latitude,
                longitude: city.longitude
            )
        } else {
            return getUsersCurrentLocation()
        }
    }

    func refreshAll() {
        refreshWeatherData()
        refreshForecastData()
    }

    func refreshWeatherData() {
        // Wrap API call in Task to avoid blocking
        Task {
            let selectedLocation = getSelectedLocation()
            if let newInfo = fetchCurrentWeather(
                latitude: selectedLocation.latitude,
                longitude: selectedLocation.longitude
            ) {
                weatherInfo = newInfo
            }
            weatherFetchCompleted = true
        }
    }

    func refreshForecastData() {
        Task {
            let selectedLocation = getSelectedLocation()
            if let newInfo = fetchForecasts(
                latitude: selectedLocation.latitude,
                longitude: selectedLocation.longitude
            ) {
                forecastInfo = newInfo
            }
            forecastFetchCompleted = true
        }
    }

    // MARK: Timer controls

    func startTimer() {
        timer = Timer.publish(every: weatherRefreshInterval, on: .main, in: .common).autoconnect()
    }

    func stopTimer() {
        timer.upstream.connect().cancel()
    }

    // MARK: Color scheme detection

    func isNight(_ weather: WeatherStruct) -> Bool {
        // Icon suffix indicates day/night
        return weather.weather[0].icon.hasSuffix("n")
    }

    func getFormColorScheme() -> ColorScheme {
        if let weather = weatherInfo {
            // Form sections look better inverted
            return isNight(weather) ? .light : .dark
        } else {
            return darkMode ? .dark : .light
        }
    }

    func getNavColorScheme() -> ColorScheme {
        if let weather = weatherInfo {
            return isNight(weather) ? .dark : .light
        } else {
            return darkMode ? .dark : .light
        }
    }

}

#Preview {
    WeatherTab()
}
