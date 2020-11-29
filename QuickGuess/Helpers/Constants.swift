//
//  Constants.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/19.
//

import Foundation

enum K {
  static let startSegue = "goToGame"
  static let backSegue = "backToStart"
  static let infoSegue = "showInfo"
  static let questionSegue = "questionEmbedded"
  static let guessSegue = "guessEmbedded"
  static let noteSegue = "noteEmbedded"
  static let messageCellIdentifier = "messageCell"
  static let messageCellNibName = "MessageTableViewCell"

  static let allCards: [Card] = {
    var result = [Card]()
    for i in 0..<20 {
      result.append(Card(i))
    }
    return result
  }()
}
