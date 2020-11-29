//
//  Message.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/21.
//

import UIKit

// MARK: - Message

struct Message {
  let sections: [MessageSection]

  init(sections: MessageSection...) {
    self.sections = sections
  }

  init(normalText: String) {
    self.sections = [MessageSection(text: normalText, color: UIColor.normalText)]
  }

  init(actionOrder list: [Player]) {
    var actionOrderText = ""
    for player in list {
      actionOrderText += player.name + "→"
    }
    actionOrderText.removeLast(1) // remove last "→"

    var sections = [MessageSection]()
    sections.append(MessageSection(text: "行動順序：", color: UIColor.normalText))
    sections.append(MessageSection(text: actionOrderText, color: UIColor.nameText))
    self.sections = sections
  }

  init(turnTo player: Player) {
    var sections = [MessageSection]()
    sections.append(MessageSection(text: "輪到", color: UIColor.normalText))
    sections.append(MessageSection(text: player.name, color: UIColor.nameText))
    sections.append(MessageSection(text: "行動——", color: UIColor.normalText))
    self.sections = sections
  }

  init(actionType: actionType, actor: Player, content: String) {
    var sections = [MessageSection]()
    sections.append(MessageSection(text: actor.name, color: UIColor.nameText))
    sections.append(MessageSection(text: actionType.rawValue, color: UIColor.normalText))
    sections.append(MessageSection(text: content, color: UIColor.highlightText))
    self.sections = sections
  }

  init(winner player: Player) {
    var sections = [MessageSection]()
    sections.append(MessageSection(text: "恭喜", color: UIColor.normalText))
    sections.append(MessageSection(text: player.name, color: UIColor.nameText))
    sections.append(MessageSection(text: "獲勝。", color: UIColor.normalText))
    self.sections = sections
  }
}

// MARK: - MessageSection

struct MessageSection {
  let text: String
  let color: UIColor
}

// MARK: - actionType

enum actionType: String {
  case ask = "提問："
  case reply = "回答："
  case guess = "猜測："
}
