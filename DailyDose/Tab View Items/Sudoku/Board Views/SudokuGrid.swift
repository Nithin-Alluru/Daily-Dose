//
//  SudokuGrid.swift
//  DailyDose
//
//  Created by CM360 on 12/2/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct SudokuGrid: View {

    @ObservedObject var game: SudokuGame

    var body: some View {
        GeometryReader { geometry in
            // A Sudoku grid is a 3x3 of squares (each containing 9 tiles)
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<3) { boxX in
                    GridRow {
                        ForEach(0..<3) { boxY in
                            SudokuBox(
                                game: game,
                                boxX: boxX,
                                boxY: boxY
                            )
                        }
                    }
                }
            }
        }
        // Force square aspect ratio
        .aspectRatio(1.0, contentMode: .fit)
        // Border around game grid for clarity
        .border(Color("ForegroundColor"), width: 2)
    }

}
