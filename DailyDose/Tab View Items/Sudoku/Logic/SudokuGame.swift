//
//  SudokuGame.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/5/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

// Our game object has the ObservableObject so we can watch for state changes
// elsewhere (grid values and selected cell coordinates).
// https://developer.apple.com/documentation/combine/observableobject
class SudokuGame: ObservableObject {

    // Current grid values
    @Published var grid: [[Int]]

    @Published var selectedX: Int
    @Published var selectedY: Int

    init(grid: [[Int]]) {
        self.grid = grid
        self.selectedX = 0
        self.selectedY = 0
    }

    func placeValue(_ value: Int) {
        guard grid.indices.contains(selectedX) && grid.indices.contains(selectedY) else {
            return
        }
        grid[selectedX][selectedY] = value
    }

}
