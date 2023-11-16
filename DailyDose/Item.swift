//
//  Item.swift
//  DailyDose
//
//  Created by CM360 on 11/16/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
