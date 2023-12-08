//
//  SudokuSaveManager.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/7/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

func gridToString(grid: [[Int]]) -> String {
    // Use flatMap to flatten the 2D grid and then join the elements into a string
    return grid.flatMap { $0.map(String.init) }.joined(separator: ",")
}

func stringToGrid(string: String) -> [[Int]]? {
    let components = string.components(separatedBy: ",")
    // Use compactMap to convert string components to integers
    let tempArray = components.compactMap { Int($0) }
    // Create a 2D grid using the new array
    let resultGrid = stride(from: 0, to: tempArray.count, by: 9).map {
        Array(tempArray[$0..<min($0 + 9, tempArray.count)])
    }
    return resultGrid
}
