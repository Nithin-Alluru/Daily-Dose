//
//  SudokuValidator.swift
//  DailyDose
//
//  Created by Aaron Gomez on 12/5/23.
//  Copyright © 2023 CS3714 Team 2. All rights reserved.
//

import Foundation

public func validateSudokuGrid(grid: [[Int]]) -> Bool {
    // Check rows
    guard validateSudokuRows(grid: grid) else {
        return false
    }

    // Check columns (transpose rows -> cols)
    let transposedGrid = transpose(matrix: grid)
    guard validateSudokuRows(grid: transposedGrid) else {
        return false
    }

    // Check boxes
    guard validateSudokuBoxes(grid: grid) else {
        return false
    }

    // Grid is valid
    return true
}

// We know a Sudoku row is valid when the values sum to 45 (1 through 9)
func validateSudokuRows(grid: [[Int]]) -> Bool {
    // Verify row sums are correct
    let sumsCorrect = grid
        .map { $0.reduce(0, +) }    // Map each row to its sum with a + reduction
        .allSatisfy { $0 == 45 }    // Check that each sum is 45
    guard sumsCorrect else {
        return false
    }

    // Verify row values are all unique
    let valuesCorrect = grid
        .map { $0.count == Set($0).count }  // Set count matches if all values are unique
        .allSatisfy { $0 }                  // Basically a long '&&' chain (Bool reduction?)
    guard valuesCorrect else {
        return false
    }

    // Rows are valid
    return true
}

func validateSudokuBoxes(grid: [[Int]]) -> Bool {
    // Verify all boxes
    for boxX in 0..<3 {
        for boxY in 0..<3 {
            guard validateSudokuBox(grid: grid, boxX: boxY, boxY: boxY) else {
                return false
            }
        }
    }

    // Boxes are valid
    return true
}

func validateSudokuBox(grid: [[Int]], boxX: Int, boxY: Int) -> Bool {
    // Box starting coordinates
    let startCellX = boxX * 3
    let startCellY = boxY * 3

    // Get box values and sum
    var sum = 0
    var values = [Int]()
    for x in startCellX..<startCellX + 3 {
        for y in startCellY..<startCellY + 3 {
            let value = grid[x][y]
            sum += value
            values.append(value)
        }
    }

    // Verify box sum is correct
    guard sum == 45 else {
        return false
    }

    // Verify box values are all unique
    guard values.count == Set(values).count else {
        return false
    }

    // Box is valid
    return true
}
