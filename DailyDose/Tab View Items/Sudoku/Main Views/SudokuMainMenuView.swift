//
//  SudokuMainMenuView.swift
//  DailyDose
//
//  Created by CM360 on 12/5/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct SudokuMainMenuView: View {

    @Binding var game: SudokuGame?

    @State private var showDifficultySheet = false

    var body: some View {
        VStack {
            Text("Sudoku")
                .font(.title)
                .padding()
            VStack {
                SudokuMenuButton(text: "New Game") {
                    showDifficultySheet = true
                }
                .actionSheet(isPresented: $showDifficultySheet, content: { difficultySheet })
                SudokuMenuButton(text: "Continue Game") {

                }
            }
            .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
        }
    }

    var difficultySheet: ActionSheet {
        ActionSheet(
            title: Text("Difficulty Selection"),
            message: Text("Select a Sudoku puzzle difficulty."),
            buttons: [
                .default(Text("Beginner")) {
                    game = SudokuGame(grid: generateSudoku(clues: 40))
                },
                .default(Text("Casual")) {
                    game = SudokuGame(grid: generateSudoku(clues: 35))
                },
                .default(Text("Moderate")) {
                    game = SudokuGame(grid: generateSudoku(clues: 30))
                },
                .default(Text("Difficult")) {
                    game = SudokuGame(grid: generateSudoku(clues: 25))
                },
                .default(Text("Expert")) {
                    game = SudokuGame(grid: generateSudoku(clues: 20))
                },
                .cancel()
            ]
        )
    }

}

struct SudokuMenuButton: View {

    let text: String
    let action: () -> ()

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 20))
                // Required for .fixedSize to work
                .frame(maxWidth: .infinity)
        }
        .tint(.blue)
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
    }

}
