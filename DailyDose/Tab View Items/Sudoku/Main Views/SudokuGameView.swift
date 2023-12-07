//
//  SudokuGameView.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/5/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import SwiftUI

struct SudokuGameView: View {

    @Environment(\.verticalSizeClass) var verticalSizeClass

    @StateObject var game: SudokuGame

    var body: some View {
        VStack{
            if verticalSizeClass == .compact {
                // Landscape orientation
                HStack {
                    SudokuGrid(game: game)
                        .padding(.trailing, 20)
                    Grid {
                        ForEach([1..<4, 4..<7, 7..<10], id: \.self) { range in
                            GridRow {
                                ForEach(range) { v in
                                    SudokuInputButton(game: game, value: v)
                                }
                            }
                        }
                        SudokuInputButton(game: game, value: 0)
                    }
                }
            } else {
                // Portrait orientation
                VStack {
                    SudokuGrid(game: game)
                        .padding(.bottom, 10)
                    Grid {
                        GridRow {
                            ForEach(1..<6) { v in
                                SudokuInputButton(game: game, value: v)
                            }
                        }
                        GridRow {
                            ForEach(6..<10) { v in
                                SudokuInputButton(game: game, value: v)
                            }
                            SudokuInputButton(game: game, value: 0)
                        }
                    }
                }
            }
        }
        .padding()
    }

}

struct SudokuInputButton: View {

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
