//
//  ResolvedCityStruct.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/8/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

struct ResolvedCityStruct: Decodable {
    let name: String
    let region_name: String
    let latitude: Double
    let longitude: Double
}
