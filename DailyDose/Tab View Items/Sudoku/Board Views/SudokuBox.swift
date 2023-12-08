//
//  SudokuBox.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/4/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct SudokuBox: View {

    @ObservedObject var game: SudokuGame

    // This box's coordinates
    let boxX: Int
    let boxY: Int

    var body: some View {
        GeometryReader { geometry in
            let frameSize = geometry.size.width / 3
            // Each box is a 3x3 of cells
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<3) { cellX in
                    GridRow {
                        ForEach(0..<3) { cellY in
                            let gridX = cellX + (3 * boxX)
                            let gridY = cellY + (3 * boxY)
                            SudokuCell(
                                game: game,
                                x: gridX,
                                y: gridY
                            )
                            .frame(width: frameSize, height: frameSize)
                        }
                    }
                }
            }
        }
        // Force square aspect ratio
        .aspectRatio(1.0, contentMode: .fit)
        // Border between boxes for clarity
        .border(Color("ForegroundColor"), width: 2)
    }

}
