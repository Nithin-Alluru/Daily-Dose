//
//  WeatherMap.swift
//  DailyDose
//
//  Created by Aaron Gomez on 11/27/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI
import MapKit

// The Map view in SwiftUI does not yet support tile overlays, so we must use
// MKMapView. Unfortunately, this is from UIKit, so we must conform to
// UIViewRepresentable in order to show OpenWeather's image tiles.
// https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit

// OpenWeather's map overlays are a bit too hard to see and offer no
// customization, so we will take a look at RainViewer as an alternative:
// https://www.rainviewer.com/api/weather-maps-api.html

struct WeatherMap: UIViewRepresentable {

    private var selectedLayer = "precipitation_new"

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .mutedStandard
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Our custom coordinator is also the MKMapViewDelegate
        // https://developer.apple.com/documentation/mapkit/mkmapview/1452115-delegate
        mapView.delegate = context.coordinator

        // Create our tile overlay with OpenWeather's image URL template
        let tileOverlay = MKTileOverlay(urlTemplate: "https://tile.openweathermap.org/map/\(selectedLayer)/{z}/{x}/{y}.png?appid=\(getWeatherApiKey())")
        mapView.addOverlay(tileOverlay, level: .aboveRoads)
    }

    // A custom coordinator is required since we want to interact with the MKMapView from
    // the rest of the app, specifically for changing the map type and visible layer.
    // https://developer.apple.com/documentation/swiftui/uiviewrepresentable/makecoordinator()-9e4i4
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    // The MKMapView uses an MKMapViewDelegate to request overlays when asynchronous
    // operations complete, specifically downloading the tile images from OpenWeather.
    // This must also inherit from NSObject to act as a coordinator.
    // https://developer.apple.com/documentation/mapkit/mkmapviewdelegate
    class Coordinator: NSObject, MKMapViewDelegate {

        // Called when the parent map view requests a renderer. MKTileOverlayRenderer
        // will be for the tile images provided by OpenWeather
        // https://developer.apple.com/documentation/mapkit/mkmapviewdelegate/1452203-mapview
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let tileOverlay = overlay as? MKTileOverlay {
                return MKTileOverlayRenderer(tileOverlay: tileOverlay)
            } else {
                // Fallback overlay renderer (not used to our knowledge)
                return MKOverlayRenderer(overlay: overlay)
            }
        }

    }

}

#Preview {
    WeatherMap()
}
