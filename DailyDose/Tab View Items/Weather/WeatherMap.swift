//
//  WeatherMap.swift
//  DailyDose
//
//  Created by CM360 on 11/28/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import MapKit

struct WeatherMap: View {

    // MKMapView map style
    @State private var mapStyle: MKMapConfiguration = MKStandardMapConfiguration()
    @State private var showStyleSettings = false

    // OpenWeather map layer
    @State private var mapLayer = "precipitation_new"
    @State private var showLayerSettings = false


    var body: some View {
        ZStack {
            WeatherMapWrapper(
                mapStyle: $mapStyle,
                layer: $mapLayer
            )
            // Foreground Layer
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            self.showStyleSettings.toggle()
                        }) {
                            Image(systemName: self.showStyleSettings ? "map.fill" : "map")
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                                .padding(.top, 10)
                                .padding(.bottom, 7)
                        }
                        .actionSheet(isPresented: $showStyleSettings, content: { styleSettings })
                        Divider()
                        Button(action: {
                            self.showLayerSettings.toggle()
                        }) {
                            Image(systemName: self.showLayerSettings ? "square.3.layers.3d.top.filled" : "square.3.layers.3d")
                                .font(Font.title.weight(.light))
                                .foregroundColor(.blue)
                                .padding(.top, 7)
                                .padding(.bottom, 10)
                        }
                        .actionSheet(isPresented: $showLayerSettings, content: { layerSettings })
                    }   // End of VStack
                    .frame(width: 40, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                    )
                    .padding()

                }   // End of HStack
                Spacer()
            }   // End of VStack – Foreground Layer
        }
    }

    var styleSettings: ActionSheet {
        ActionSheet(
            title: Text("Map Style Settings"),
            message: Text("Select Map Style"),
            buttons: [
                .default(Text("Standard")) {
                    mapStyle = MKStandardMapConfiguration()
                },
                .default(Text("Satellite")) {
                    mapStyle = MKImageryMapConfiguration()
                },
                .default(Text("Hybrid")) {
                    mapStyle = MKHybridMapConfiguration()
                },
                .cancel() {
                    showStyleSettings = false
                }
            ]
        )
    }

    var layerSettings: ActionSheet {
        ActionSheet(
            title: Text("Map Layer Settings"),
            message: Text("Select Map Layer"),
            buttons: [
                .default(Text("Clouds")) {
                    mapLayer = "clouds_new"
                },
                .default(Text("Precipitation")) {
                    mapLayer = "precipitation_new"
                },
                .default(Text("Sea level pressure")) {
                    mapLayer = "pressure_new"
                },
                .default(Text("Wind speed")) {
                    mapLayer = "wind_new"
                },
                .default(Text("Temperature")) {
                    mapLayer = "temp_new"
                },
                .cancel() {
                    showLayerSettings = false
                }
            ]
        )
    }

}

#Preview {
    WeatherMap()
}
