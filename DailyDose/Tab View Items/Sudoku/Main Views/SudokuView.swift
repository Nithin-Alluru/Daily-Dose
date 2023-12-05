//
//  SudokuView.swift
//  DailyDose
//
//  Created by CM360 on 12/2/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct SudokuView: View {

    let exampleValues = [
        [1,2,3,  4,5,6,  7,8,9],
        [4,5,6,  7,8,9,  1,2,3],
        [7,8,9,  1,2,3,  4,5,6],

        [2,3,1,  5,6,4,  8,9,7],
        [5,6,4,  8,9,7,  2,3,1],
        [8,9,7,  2,3,1,  5,6,4],

        [3,1,2,  6,4,5,  9,7,8],
        [6,4,5,  9,7,8,  3,1,2],
        [9,7,8,  3,1,2,  6,4,5],
    ]

    @State private var game: SudokuGame?

    var body: some View {
        if let activeGame = game {
            SudokuGameView(game: activeGame)
        } else {
            SudokuMainMenuView(game: $game)
        }
    }

}

#Preview {
    SudokuView()
}
