//
//  MinesweeperState.swift
//  Katana
//
//  Copyright © 2016 Bending Spoons.
//  Distributed under the MIT License.
//  See the LICENSE file for more information.

import Katana

struct MinesweeperState: State {
  var gameOver: Bool
  let rows: Int
  let cols: Int
  var mines: [Bool]
  var disclosed: [Bool]
  
  init() {
    self.init(difficulty: .hard)
  }
  
  init(difficulty: Difficulty) {
    switch difficulty {
    case .easy:
      self.init(cols: 9, rows: 9, mines: 10)
    case .medium:
      self.init(cols: 15, rows: 16, mines: 35)
    case .hard:
      self.init(cols: 15, rows: 30, mines: 90)
    }
  }
  
  private init(cols: Int, rows: Int, mines: Int) {
    self.gameOver = false
    self.rows = rows
    self.cols = cols
    self.mines = Array(repeating: false, count: rows * cols)
    self.disclosed = Array(repeating: false, count: rows * cols)
    self.poseMines(numberOfMines: mines)
  }
  
}


// MARK: - mines operations
extension MinesweeperState {
  fileprivate mutating func poseMines(numberOfMines: Int) {
    var i = 0
    while i < numberOfMines {
      let r = Int.random(max: rows)
      let c = Int.random(max: cols)
      if( self[c, r] != true) {
        i += 1
        self[c, r] = true
      }
    }
  }
  
  func minesNearbyCellAt(col: Int, row: Int) -> Int {
    var mines = 0
    for index in self.nearbyCellsIndicesAt(col: col, row: row) {
      if(self[index.0, index.1]) {
        mines += 1
      }
    }
    return mines
  }
  
  func nearbyCellsIndicesAt(col: Int, row: Int) -> [(Int, Int)] {
    var indices: [(Int, Int)] = []
    let startCol = col - 1
    let endCol = col + 1
    let startRow = row - 1
    let endRow = row + 1
    for currentCol in startCol...endCol {
      for currentRow in startRow...endRow {
        
        guard currentCol >= 0 && currentCol < cols else {
          continue
        }
        
        guard currentRow >= 0 && currentRow < rows else {
          continue
        }
        
        if currentRow == row && currentCol == col {
          continue
        }
        
        indices.append((currentCol, currentRow))
      }
    }
    return indices
  }
  
  subscript(col: Int, row: Int) -> Bool {
    get { return mines[cols * row + col] }
    set { mines[cols*row+col] = newValue }
  }
}


// MARK: - Disclosure
extension MinesweeperState {
  mutating func disclose(col: Int, row: Int) {
    disclosed[cols*row+col] = true
  }
  
  func isDisclosed(col: Int, row: Int) -> Bool {
    return disclosed[cols*row+col]
  }
}

// MARK: - Difficulty
extension MinesweeperState {
  enum Difficulty {
    case easy, medium, hard
  }
}


// MARK: - Equality
extension MinesweeperState {
  
  static func == (lhs: MinesweeperState, rhs: MinesweeperState) -> Bool {
    return lhs.mines == rhs.mines && lhs.disclosed == rhs.disclosed
  }
}

// MARK: - Utils
extension Int {
  static func random(max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)))
  }
}
