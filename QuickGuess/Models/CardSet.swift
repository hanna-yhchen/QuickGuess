//
//  CardSet.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/19.
//

import Foundation

// MARK: - CardSet

class CardSet {
  let cards: [Card]

  init(with cards: [Card]) {
    self.cards = cards.sorted()
  }

  /// Sum of all numbers in the card set.
  func sum() -> Int {
    var result = 0
    for card in cards {
      result += card.number
    }
    return result
  }

  /// Sum of the left three numbers in the card set.
  func leftSum() -> Int {
    var result = 0
    for i in 0..<3 {
      result += cards[i].number
    }
    return result
  }

  /// Sum of the right three numbers in the card set.
  func rightSum() -> Int {
    var result = 0
    let start = cards.count - 3
    for i in start..<cards.count {
      result += cards[i].number
    }
    return result
  }

  /// Sum of the center three three numbers in the card set.
  func centerSum() -> Int {
    var result = 0
    for i in 1...3 {
      result += cards[i].number
    }
    return result
  }

  /// Sum of the numbers of cards with the given color in the card set.
  func sumOfColor(_ color: CardColor) -> Int {
    var result = 0
    if let positions = positionsOfColor(color) {
      for i in positions {
        result += cards[i].number
      }
    }
    return result
  }

  /// The collection of positions where the given color are; return `nil` if there is no such color in the card set.
  func positionsOfColor(_ color: CardColor) -> [Int]? {
    var result = [Int]()
    for i in 0..<cards.count {
      if cards[i].color == color {
        result.append(i)
      }
    }
    return result.isEmpty ? nil : result
  }

  /// The difference between the maximum and the minimum number in the card set.
  func difference() -> Int {
    return cards.last!.number - cards.first!.number
  }

  /// The count of the even numbers in the card set.
  func countOfEven() -> Int {
    var count = 0
    for card in cards {
      count += card.number.isMultiple(of: 2) ? 1 : 0
    }
    return count
  }

  /// The count of the odd numbers in the card set.
  func countOfOdd() -> Int {
    let even = countOfEven()
    return cards.count - even
  }

  /// The count of the given color in the card set.
  func countOfColor(_ color: CardColor) -> Int {
    var count = 0
    for card in cards {
      count += card.color == color ? 1 : 0
    }
    return count
  }

  /// The count of the pairs of cards with same numbers in the card set.
  func countOfPairs() -> Int {
    var count = 0
    for i in 0..<cards.count - 1 {
      let former = cards[i].number
      let latter = cards[i + 1].number
      count += former == latter ? 1 : 0
    }
    return count
  }

  /// The collection of positions where the sequential numbers are; return `nil` if there are no sequential numbers in the card set.
  func positionsOfSequentialNumber() -> [[Int]]? {
    var result = [[Int]]()
    var sequence = [Int]()
    for i in 0..<cards.count - 1 {
      let former = cards[i].number
      let latter = cards[i + 1].number
      let isSequential = former + 1 == latter
      if isSequential {
        if sequence.isEmpty {
          sequence.append(i)
        }
        sequence.append(i + 1)
      } else if !sequence.isEmpty {
        result.append(sequence)
        sequence.removeAll()
      }
    }
    // Catch the sequence involving the last card
    if !sequence.isEmpty {
      result.append(sequence)
    }
    
    if result == [] {
      return nil
    }
    return result
  }

  /// The collection of positions where the contiguous cards with same color are; return `nil` if there are no such contiguous cards in the card set.
  func positionsOfContiguousColor() -> [[Int]]? {
    var result = [[Int]]()
    var sequence = [Int]()
    for i in 0..<cards.count - 1 {
      let former = cards[i].color
      let latter = cards[i + 1].color
      let isContiguous = former == latter
      if isContiguous {
        if sequence.isEmpty {
          sequence.append(i)
        }
        sequence.append(i + 1)
      } else if !sequence.isEmpty {
        result.append(sequence)
        sequence.removeAll()
      }
    }
    if !sequence.isEmpty {
      result.append(sequence)
    }
    if result == [] {
      return nil
    }
    return result
  }

  /// The collection of positions where the given number are; return `nil` if there is no such number in the card set.
  func positionsOfNumber(_ number: Int) -> [Int]? {
    var result = [Int]()
    for i in 0..<cards.count {
      if cards[i].number == number {
        result.append(i)
      }
    }
    return result.isEmpty ? nil : result
  }

  /// Return true if the number at the given index greater than the given number.
  func isGreater(than number: Int, at index: Int) -> Bool {
    return cards[index].number > number ? true : false
  }
}

// MARK: - Hashable

extension CardSet: Hashable {
  static func == (lhs: CardSet, rhs: CardSet) -> Bool {
    return lhs.cards == rhs.cards
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(cards)
  }
}
