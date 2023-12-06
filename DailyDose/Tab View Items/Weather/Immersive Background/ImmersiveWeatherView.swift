//
//  ImmersiveWeatherView.swift
//  DailyDose
//
//  Created by CM360 on 11/27/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

// For converting OpenWeather icon codes to SF Symbol names
// https://openweathermap.org/weather-conditions
fileprivate let weatherBackgrounds = [
    // clear sky
    "d": ImmersiveSceneStruct(
        gradient: [0x73b1e6, 0xa5c9e8],
        layers: []
    ),
    "n": ImmersiveSceneStruct(
        gradient: [0x0e0a14, 0x1d1d43],
        layers: ["Immersive Weather/Stars"]
    ),
]

struct ImmersiveWeatherView: View {

   let currentWeather: String

    var body: some View {
        ZStack {
            let currentScene = weatherBackgrounds["\(currentWeather.dropFirst(2))"] ?? weatherBackgrounds["d"]!
            LinearGradient(
                gradient: Gradient(colors: currentScene.gradient.map { Color(hex: $0) }),
                startPoint: .top,
                endPoint: .bottom
            )
            ForEach(currentScene.layers, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }

}
