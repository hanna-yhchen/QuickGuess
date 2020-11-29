//
//  GuessViewController.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/24.
//

import UIKit

// MARK: - GuessViewController

class GuessViewController: UIViewController {
  @IBOutlet var cardFieldViews: [UIView]!
  @IBOutlet var cardFields: [UIButton]!
  @IBOutlet var cards: [UIButton]!


  var delegate: GuessVCDelegate!
  var playerCards: [Card]!
  var selectedIndex = 0
  var selectedCards = [Card?]()

  override func viewDidLoad() {
    super.viewDidLoad()

    cardFieldViews.sort()
    cardFields.sort()
    cards.sort()


    // Setup card fields & cards
    if playerCards.count == 4 {
      cardFieldViews[4].isHidden = true
      selectedCards = Array(repeating: nil, count: 4)
    } else {
      selectedCards = Array(repeating: nil, count: 5)
    }
    adaptingDisplay(to: 0)
  }
}

// MARK: - Actions

extension GuessViewController {
  @IBAction func cardFieldSelected(_ sender: UIButton) {
    adaptingDisplay(to: sender.tag)
  }

  @IBAction func cardSelected(_ sender: UIButton) {
    let selectedCard = Card(sender.tag)
    selectedCards[selectedIndex] = selectedCard

    let cardText = String(selectedCard.number)
    let cardColor = Helper.cardUIColor(of: selectedCard.color)
    let attributedString = NSAttributedString(
      string: cardText,
      attributes: [.foregroundColor: cardColor])
    cardFields[selectedIndex].setAttributedTitle(attributedString, for: .normal)
    
    // Automatically switch to next field if available
    let nextIndex = selectedIndex + 1
    if nextIndex < playerCards.count {
      adaptingDisplay(to: nextIndex)
    }
  }

  @IBAction func resetPressed(_: UIButton) {
    selectedCards = selectedCards.map { _ in nil }
    for i in 0..<cardFields.count {
      cardFields[i].setAttributedTitle(nil, for: .normal)
    }
    
    selectedIndex = 0
    adaptingDisplay(to: selectedIndex)
  }

  @IBAction func guessPressed(_: UIButton) {
    guard !selectedCards.contains(nil) else {
      showAlert(title: "無法猜測", message: "選擇的數字卡不足。")
      return
    }

    let guess = selectedCards.compactMap { $0 }
    var guessText = ""
    for card in guess {
      let color = card.color.rawValue
      let number = card.number
      guessText += "\(color)\(number)、"
    }
    guessText.removeLast()
    showAlert(title: "猜測", message: guessText) { _ in
      self.delegate.didGuess(CardSet(with: guess))
    }
  }
}

// MARK: - Methods

extension GuessViewController {
  private func adaptingDisplay(to selectedIndex: Int) {
    self.selectedIndex = selectedIndex
    resetDisplay()
    
    cardFieldViews[selectedIndex].layer.borderWidth = 2

    var toDisable = [Int]()
    for card in playerCards {
      let tag = card.id
      toDisable.append(tag)
    }

    if selectedIndex > 1 {
      toDisable.append(0)
      toDisable.append(1)
    }
    if selectedIndex > 3 {
      toDisable.append(2)
      toDisable.append(3)
    }

    // TODO: to disable cards exceeding upper bound
//    let lastIndex = playerCards.count - 1
//    if selectedIndex < lastIndex - 1 {
//      toDisable.append(18)
//      toDisable.append(19)
//    }
//    if selectedIndex < lastIndex - 3 {
//      toDisable.append(17)
//      toDisable.append(16)
//    }

    // Disable certain cards according to previous choices
    let previousIndex = selectedIndex - 1
    if previousIndex >= 0 {
      let previousCards = selectedCards[0...previousIndex]
      for card in Array(previousCards) {
        if card != nil {
          let tag = card!.id
          if tag == 12 {
            // Exception: green 5
            for i in 0...10 {
              toDisable.append(i)
            }
          } else {
            for i in 0...tag {
              toDisable.append(i)
            }
          }
        }
      }
    }

    for tag in toDisable {
      cards[tag].alpha = 0.3
      cards[tag].isEnabled = false
    }
  }

  private func resetDisplay() {
    for i in 0..<cardFieldViews.count {
      cardFieldViews[i].layer.borderWidth = 0
    }
    for i in 0..<cards.count {
      cards[i].alpha = 1
      cards[i].isEnabled = true
    }
  }
}

// MARK: - GuessVCDelegate

protocol GuessVCDelegate {
  func didGuess(_ guess: CardSet)
}
