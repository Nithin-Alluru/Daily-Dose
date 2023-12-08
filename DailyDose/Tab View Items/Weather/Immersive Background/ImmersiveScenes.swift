//
//  ImmersiveScenes.swift
//  DailyDose
//
//  Created by Aaron Gomez on 11/28/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct ImmersiveSceneStruct {
    let gradient: [UInt]
    let layers: [String]
}

struct ImmersiveLayerStruct {
    let image: String
    let scrollDirection: Edge
    let scrollDuration: Double
}
