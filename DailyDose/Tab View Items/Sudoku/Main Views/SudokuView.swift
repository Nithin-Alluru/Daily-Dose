//
//  SudokuView.swift
//  DailyDose
//
//  Created by CM360 on 12/2/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct SudokuView: View {

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
