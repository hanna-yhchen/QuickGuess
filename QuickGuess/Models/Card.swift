//
//  Card.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/19.
//

import Foundation

// MARK: - Card

struct Card: Hashable, Comparable {
  let id: Int
  let number: Int
  let color: CardColor

  init(_ id: Int) {
    self.id = id
    switch id {
      case 0:
        self.number = 0
        self.color = .red
      case 1:
        self.number = 0
        self.color = .blue
      case 2:
        self.number = 1
        self.color = .red
      case 3:
        self.number = 1
        self.color = .blue
      case 4:
        self.number = 2
        self.color = .red
      case 5:
        self.number = 2
        self.color = .blue
      case 6:
        self.number = 3
        self.color = .red
      case 7:
        self.number = 3
        self.color = .blue
      case 8:
        self.number = 4
        self.color = .red
      case 9:
        self.number = 4
        self.color = .blue
      case 10:
        self.number = 5
        self.color = .green
      case 11:
        self.number = 5
        self.color = .green
      case 12:
        self.number = 6
        self.color = .red
      case 13:
        self.number = 6
        self.color = .blue
      case 14:
        self.number = 7
        self.color = .red
      case 15:
        self.number = 7
        self.color = .blue
      case 16:
        self.number = 8
        self.color = .red
      case 17:
        self.number = 8
        self.color = .blue
      case 18:
        self.number = 9
        self.color = .red
      case 19:
        self.number = 9
        self.color = .blue
      default:
        print("Illegal card id!")
        self.number = 99
        self.color = .green
    }
  }

  static func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.id == rhs.id
  }

  static func < (lhs: Card, rhs: Card) -> Bool {
    return lhs.id < rhs.id
  }
}

// MARK: - CardColor

enum CardColor: String {
  typealias text = String
  case red = "紅"
  case blue = "藍"
  case green = "綠"
}
