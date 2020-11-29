//
//  Player.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/19.
//

import Foundation

// MARK: - Player

class Player {
  // MARK: - Properties

  let name: String
  let cardSet: CardSet

  // MARK: - Initialization

  init(name: String, cards: [Card]) {
    self.name = name
    self.cardSet = CardSet(with: cards)
  }
}

// MARK: - Hashable

extension Player: Hashable {
  static func == (lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
}
