//
//  SudokuGameView.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/5/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct SudokuGameView: View {

    // View orientation detection
    @Environment(\.verticalSizeClass) var verticalSizeClass

    // Currently active game
    @State var activeGame: SudokuGame?
    // Saved game
    @AppStorage("savedSudoku") private var savedSudoku: String?

    // Difficulty select sheet and confirmations
    @State private var showDifficultySheet = false
    @State private var showAlert = false
    @State private var activeAlert = ActiveSudokuAlert.exit

    var body: some View {
        NavigationStack {
            VStack{
                if verticalSizeClass == .compact {
                    // Landscape orientation
                    HStack {
                        if let game = activeGame {
                            SudokuGrid(game: game)
                                .padding(.trailing, 20)
                            SudokuKeypadLandscape(game: game)
                        } else {
                            menuButtons
                        }
                    }
                } else {
                    // Portrait orientation
                    VStack {
                        Text("Sudoku")
                            .font(.title)
                        if let game = activeGame {
                            SudokuGrid(game: game)
                                .padding(.vertical, 15)
                            SudokuKeypadPortrait(game: game)
                        } else {
                            menuButtons
                        }
                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if activeGame != nil {
                            activeAlert = .exit
                            showAlert = true
                        }
                    }) {
                        Image(systemName: "multiply")
                    }
                }
            }
            // Exit confirmation
            .alert(isPresented: $showAlert) {
                switch activeAlert {
                case .exit:
                    return Alert(
                        title: Text("Exit Confirmation"),
                        message: Text("Are you sure you want to exit this game? You can return to it later."),
                        primaryButton: .destructive(Text("Exit")) {
                            if let game = activeGame {
                                savedSudoku = gridToString(grid: game.grid)
                                activeGame = nil
                            }
                        },
                        secondaryButton: .cancel()
                    )   // End of alert
                case .overwrite:
                    // Overwrite confirmation
                    return Alert(
                        title: Text("Overwrite Confirmation"),
                        message: Text("You have a saved game that will be overwritten. Continue with a new game?"),
                        primaryButton: .destructive(Text("Overwrite")) {
                            showDifficultySheet = true
                        },
                        secondaryButton: .cancel()
                    )   // End of alert
                }
            }
        }
    }

    var menuButtons: some View {
        VStack {
            SudokuMenuButton(text: "New Game") {
                if savedSudoku == nil {
                    showDifficultySheet = true
                } else {
                    activeAlert = .overwrite
                    showAlert = true
                }
            }
            .actionSheet(isPresented: $showDifficultySheet, content: { difficultySheet })
            if let saveString = savedSudoku {
                SudokuMenuButton(text: "Continue Game") {
                    if let savedGrid = stringToGrid(string: saveString) {
                        activeGame = SudokuGame(grid: savedGrid)
                    } else {
                        // Broken save, ignore
                        savedSudoku = nil
                    }
                }
            }
        }
        .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false)
        .padding()
    }

    var difficultySheet: ActionSheet {
        ActionSheet(
            title: Text("Difficulty Selection"),
            message: Text("Select a Sudoku puzzle difficulty."),
            buttons: [
                .default(Text("Beginner")) {
                    activeGame = SudokuGame(grid: generateSudoku(clues: 40))
                },
                .default(Text("Casual")) {
                    activeGame = SudokuGame(grid: generateSudoku(clues: 35))
                },
                .default(Text("Moderate")) {
                    activeGame = SudokuGame(grid: generateSudoku(clues: 30))
                },
                .default(Text("Difficult")) {
                    activeGame = SudokuGame(grid: generateSudoku(clues: 25))
                },
                .default(Text("Expert")) {
                    activeGame = SudokuGame(grid: generateSudoku(clues: 20))
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
                // Required for .fixedSize to work externally
                .frame(maxWidth: .infinity)
        }
        .tint(.blue)
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
    }

}

struct SudokuKeypadButton: View {

    // Frame sizing constants
    let frameWidth = 25.0
    let frameHeight = 30.0

    @StateObject var game: SudokuGame

    // This button's value
    let value: Int

    var body: some View {
        Button(action: {
            game.placeValue(value)
        }) {
            if value > 0 {
                Text("\(value)")
                    .frame(width: frameWidth, height: frameHeight)
            } else {
                Image(systemName: "delete.backward")
                    .frame(width: frameWidth, height: frameHeight)
            }
        }
        .font(.system(size: 24))
        .tint(.blue)
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle)
    }

}

struct SudokuKeypadPortrait: View {

    @StateObject var game: SudokuGame

    var body: some View {
        Grid {
            GridRow {
                ForEach(1..<6) { v in
                    SudokuKeypadButton(game: game, value: v)
                }
            }
            GridRow {
                ForEach(6..<10) { v in
                    SudokuKeypadButton(game: game, value: v)
                }
                SudokuKeypadButton(game: game, value: 0)
            }
        }
    }
}

struct SudokuKeypadLandscape: View {

    @StateObject var game: SudokuGame

    var body: some View {
        Grid {
            ForEach([1..<4, 4..<7, 7..<10], id: \.self) { range in
                GridRow {
                    ForEach(range) { v in
                        SudokuKeypadButton(game: game, value: v)
                    }
                }
            }
            SudokuKeypadButton(game: game, value: 0)
        }
    }

}

enum ActiveSudokuAlert {
    case exit, overwrite
}
