//
//  DynamicWeatherBackground.swift
//  DailyDose
//
//  Created by CM360 on 11/27/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

let sunnyGradient = Gradient(colors: [Color(hex: 0x73b1e6), Color(hex: 0xa5c9e8)])
let rainyGradient = Gradient(colors: [Color(hex: 0x1b3045), Color(hex: 0x8196ab)])

struct DynamicWeatherBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: sunnyGradient,
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

#Preview {
    DynamicWeatherBackground()
}

