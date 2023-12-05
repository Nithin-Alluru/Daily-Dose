//
//  SudokuCell.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/2/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct SudokuCell: View {

    @ObservedObject var game: SudokuGame

    // This cell's coordinates
    let x: Int
    let y: Int

    var body: some View {
        GeometryReader { geometry in
            let value = game.grid[x][y]
            Text(value > 0 ? "\(value)" : " ")
                // Force fit to outer frame size
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                // Text should automatically fit inside this cell's frame, we can scale it
                // down automatically from an (essentially) infinite size to a minimum of 10
                .font(.system(size: 1000))
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                // Background color indicates selection status
                .background(isCellSelected() ? .blue.opacity(0.5) : (isRowOrColSelected() ? .blue.opacity(0.2) : .clear))
                // Border between cells for clarity
                .border(Color("ForegroundColor"), width: 1)
                // Select cell on tap
                .onTapGesture() {
                    game.selectedX = x
                    game.selectedY = y
                }
        }
    }

    func isCellSelected() -> Bool {
        return x == game.selectedX && y == game.selectedY
    }

    func isRowOrColSelected() -> Bool {
        return x == game.selectedX || y == game.selectedY
    }

}
