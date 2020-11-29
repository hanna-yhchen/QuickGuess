//
//  Computer.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/19.
//

import Foundation

// MARK: - Computer

class Computer: Player {
  // MARK: - Properties

  private var candidateLists = [Player: [CardSet]]()

  // MARK: - Setup Methods

  func initializeCandidateLists(from allPlayers: [Player]) {
    // Get the rest of cards by removing cards of self
    let myCards = cardSet.cards
    let theRestOfCards = K.allCards.filter { !myCards.contains($0) }

    // Get all possible combinations from the rest of cards
    let numberOfCards = myCards.count
    let candidateCardSets = combinations(taking: numberOfCards, from: theRestOfCards)

    // Initialize candidate lists
    let opponents = allPlayers.filter { $0 != self }
    opponents.forEach { player in
      candidateLists.updateValue(candidateCardSets, forKey: player)
    }
  }
}

// MARK: - Methods

extension Computer {
  func shouldGuess() -> Bool {
    // TODO: Make computer guess if possibilities < 5
    let allCandidateLists = candidateLists.values
    var possibleSet = 1
    for candidatelist in allCandidateLists {
      possibleSet *= candidatelist.count
    }
    if possibleSet < 5 {
      return true
    }
    return false
  }

  func guess() -> CardSet {
    let numberOfOpponents = candidateLists.count
    if numberOfOpponents == 1 {
      let candidateList: [CardSet] = candidateLists.values.first!
      let range = 0..<candidateList.count
      let toPick = Int.random(in: range)
      let guess = candidateList[toPick]
      return guess
    }

    let numberOfCards = cardSet.cards.count
    let numberOfCardsToRemove = 20 - (2 * numberOfCards)

    var toRemove = Set<Card>()
    let allCandidateLists = candidateLists.values
    // Combine candidate cardset of each player randomly
    repeat {
      for candidateList in allCandidateLists {
        let range = 0..<candidateList.count
        let toPick = Int.random(in: range)
        let cardSetToPick: CardSet = candidateList[toPick]
        for card in cardSetToPick.cards {
          toRemove.insert(card)
        }
      }
      if toRemove.count < numberOfCardsToRemove {
        toRemove.removeAll()
      }
    } while toRemove.isEmpty
    let allCards = K.allCards
    let myCards = cardSet.cards
    let cardsToGuess = allCards.filter { !toRemove.contains($0) && !myCards.contains($0) }
    let guess = CardSet(with: cardsToGuess)
    return guess
  }
  
  func filter(_ targetPlayers: [Player], by question: Question) {
    for player in targetPlayers {
      // Ensure the target included in the list
      if let listToFilter = candidateLists[player] {
        var listToKeep = [CardSet]()
        let tester = player.cardSet
        for testee in listToFilter {
          var shouldKeep = false
          switch question.id {
            case 0:
              // "所有紅色數字卡相加的總和是多少？"
              shouldKeep = testee.sumOfColor(.red) == tester.sumOfColor(.red)
            case 1:
              // "所有藍色數字卡相加的總和是多少？"
              shouldKeep = testee.sumOfColor(.blue) == tester.sumOfColor(.blue)
            case 2:
              // "左邊三張數字卡相加的總和是多少？"
              shouldKeep = testee.leftSum() == tester.leftSum()
            case 3:
              // "右邊三張數字卡相加的總和是多少？"
              shouldKeep = testee.rightSum() == tester.rightSum()
            case 4:
              // "有幾對相同的數字卡？"
              shouldKeep = testee.countOfPairs() == tester.countOfPairs()
            case 5:
              // "有幾張紅色數字卡？"
              shouldKeep = testee.countOfColor(.red) == tester.countOfColor(.red)
            case 6:
              // "有幾張藍色數字卡？"
              shouldKeep = testee.countOfColor(.blue) == tester.countOfColor(.blue)
            case 7:
              // "有幾張奇數卡？"
              shouldKeep = testee.countOfOdd() == tester.countOfOdd()
            case 8:
              // "有幾張偶數卡？"
              shouldKeep = testee.countOfEven() == tester.countOfEven()
            case 9:
              // "連續數字的卡片在哪幾個位置？"
              shouldKeep = testee.positionsOfSequentialNumber() == tester
                .positionsOfSequentialNumber()
            case 10:
              // "顏色相同並且相鄰的數字卡在哪幾個位置？"
              shouldKeep = testee.positionsOfContiguousColor() == tester
                .positionsOfContiguousColor()
            case 11:
              // "數字1在哪個位置？"
              shouldKeep = testee.positionsOfNumber(1) == tester.positionsOfNumber(1)
            case 12:
              // "數字2在哪個位置？"
              shouldKeep = testee.positionsOfNumber(2) == tester.positionsOfNumber(2)
            case 13:
              // "數字3在哪個位置？"
              shouldKeep = testee.positionsOfNumber(3) == tester.positionsOfNumber(3)
            case 14:
              // "數字4在哪個位置？"
              shouldKeep = testee.positionsOfNumber(4) == tester.positionsOfNumber(4)
            case 15:
              // "數字5在哪個位置？"
              shouldKeep = testee.positionsOfNumber(5) == tester.positionsOfNumber(5)
            case 16:
              // "數字6在哪個位置？"
              shouldKeep = testee.positionsOfNumber(6) == tester.positionsOfNumber(6)
            case 17:
              // "數字7在哪個位置？"
              shouldKeep = testee.positionsOfNumber(7) == tester.positionsOfNumber(7)
            case 18:
              // "數字8在哪個位置？"
              shouldKeep = testee.positionsOfNumber(8) == tester.positionsOfNumber(8)
            case 19:
              // "數字9在哪個位置？"
              shouldKeep = testee.positionsOfNumber(9) == tester.positionsOfNumber(9)
            case 20:
              // "數字0在哪個位置？"
              shouldKeep = testee.positionsOfNumber(0) == tester.positionsOfNumber(0)

            case 21:
              // "所有數字卡相加的總和是多少？（共享）"
              shouldKeep = testee.sum() == tester.sum()
            case 22:
              // "最大的數字卡與最小的數字卡相差多少？（共享）"
              shouldKeep = testee.difference() == tester.difference()
            case 23:
              // "中間的數字卡大於4嗎？（共享）"
              shouldKeep = testee.isGreater(than: 4, at: 2) == tester.isGreater(than: 4, at: 2)
            case 24:
              // "中間三張數字卡相加的總和是多少？"
              shouldKeep = testee.centerSum() == tester.centerSum()
            default:
              print("Illegal question id!")
          }
          if shouldKeep {
            listToKeep.append(testee)
          }
        }
        candidateLists[player] = listToKeep
      }
    }
  }
}

// MARK: - Private Methods

extension Computer {
  private func combinations(taking k: Int, from cards: [Card]) -> [CardSet] {
    var cardSets = [CardSet]()
    let n = cards.count // n
    var combination = Array(cards[0..<k])

    func processing(
      combination: inout [Card],
      into result: inout [CardSet],
      startIndex: Int,
      currentIndex: Int) {
      guard currentIndex < k else {
        let finishedCombination = combination
        result.append(CardSet(with: finishedCombination))
        return
      }
      let endIndex = n - k + currentIndex
      let rangeToTake = startIndex...endIndex
      for toTake in rangeToTake {
        combination[currentIndex] = cards[toTake]
        processing(
          combination: &combination,
          into: &result,
          startIndex: toTake + 1,
          currentIndex: currentIndex + 1)
      }
    }

    processing(combination: &combination, into: &cardSets, startIndex: 0, currentIndex: 0)
    return cardSets
  }
}
