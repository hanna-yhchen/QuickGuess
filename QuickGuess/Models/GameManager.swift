//
//  GameManager.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/20.
//

import Foundation

// MARK: - GameManager

class GameManager {
  // MARK: - Properties

  private let numberOfPlayers: Int
  private var players = [Player]()
  private var human: Player!
  private var computers = [Computer]()
  private var questions = [Question]()
  private var answer: CardSet?
  private var turn = 0

  var questionHolders = [Question?]()
  var shouldEnd = false
  var winner: Player?

  var delegate: GameManagerDelegate!

  // MARK: - Initialization

  init(numberOfPlayers: Int) {
    self.numberOfPlayers = numberOfPlayers
  }

  // MARK: - Setup Method

  func setup() {
    // Questions setup
    for id in 0...22 {
      questions.append(Question(id))
    }
    if numberOfPlayers < 4 {
      questions.append(Question(23))
      questions.append(Question(24))
    }
    questions.shuffle()
    
    // Debug
    print("Setup for \(numberOfPlayers)-players game.")
    print("--Question order:")
    for question in questions {
      print(question.id, terminator: " ")
    }
   print("")
    
    for _ in 0..<6 {
      let toAppend = questions.removeFirst()
      questionHolders.append(toAppend)
    }

    // Cards setup
    let shuffledCards = K.allCards.shuffled()
    var groupedCards = [[Card]]()
    if numberOfPlayers < 4 {
      // 5 cards dealt for 2~3-players game
      for i in 0..<4 {
        let start = 5 * i
        let end = start + 4
        let cards = Array(shuffledCards[start...end])
        groupedCards.append(cards)
      }
    } else {
      // 4 cards dealt for 4-players game
      for i in 0..<5 {
        let start = 4 * i
        let end = start + 3
        let cards = Array(shuffledCards[start...end])
        groupedCards.append(cards)
      }
    }

    // Players/Computer/Answer setup
    players.append(Player(name: "玩家", cards: groupedCards[0]))
    human = players[0]

    players.append(Computer(name: "電腦A", cards: groupedCards[1]))
    if numberOfPlayers > 2 {
      players.append(Computer(name: "電腦B", cards: groupedCards[2]))
      answer = CardSet(with: groupedCards.last!)
    }
    if numberOfPlayers > 3 {
      players.append(Computer(name: "電腦C", cards: groupedCards[3]))
    }

    players.forEach { player in
      if let computer = player as? Computer {
        computers.append(computer)
        computer.initializeCandidateLists(from: players)
      }
    }

    players.shuffle()

    // Debug
    print("--Action order:")
    for player in players {
      print(player.name, terminator: " ")
    }
    print("")
    for player in players {
      let name = player.name
      print("--\(name)'s cards:")
      let cards = player.cardSet.cards
      for card in cards {
        print("\(card.number), \(card.color)")
      }
    }
    if let answer = answer {
      print("--Answer's cards:")
      let cards = answer.cards
      for card in cards {
        print("\(card.number), \(card.color)")
      }
    }
  }

  func playerCards() -> [Card] {
    let player = players.first { !($0 is Computer) }
    return (player?.cardSet.cards)!
  }
}

// MARK: - Game Processing Methods

extension GameManager {
  func openning() {
    delegate.appendMessage(Message(normalText: "開始\(numberOfPlayers)人遊戲——"))
    delegate.appendMessage(Message(actionOrder: players))
  }
  
  func nextQuestion(at index: Int) -> Question? {
    guard questions.count > 0 else {
      return nil
    }
    let next = questions.removeFirst()
    questionHolders[index] = next
    return next
  }

  func nextPlayer() -> Player {
    let next = turn % numberOfPlayers
    turn += 1
    return players[next]
  }

  func isAnyQuestionAvailable() -> Bool {
    let nonNils = questionHolders.compactMap { $0 }
    return !nonNils.isEmpty
  }

  func turn(to actor: Computer) {
    if actor.shouldGuess() {
      let guess = actor.guess()
      print("\(actor.name) guess \(guess)")
      self.guess(guess, by: actor)
    } else {
      // Pick a question randomly
      var toPick: Int
      var question: Question?
      repeat {
        toPick = Int.random(in: 0..<6)
        question = questionHolders[toPick]
      } while question == nil

      toPick = Int.random(in: 0..<6)
      question = questionHolders[toPick]

      print("\(actor.name) ask \(question!.text)")
      ask(question!, by: actor)

      delegate.didAskQuestion(at: toPick)
    }
  }

  func playerAsk(at index: Int) {
    let question = questionHolders[index]

    print("\(human.name) ask \(question!.text)")
    ask(question!, by: human)

    delegate.didAskQuestion(at: index)
  }

  private func ask(_ question: Question, by actor: Player) {
    delegate.appendMessage(Message(actionType: .ask, actor: actor, content: question.text))

    // Reply
    var repliers = players
    // Questions 21~23 are public
    if question.id < 21 || question.id == 24 {
      repliers = players.filter { $0 != actor }
    }
    for replier in repliers {
      let replyText = reply(to: question, by: replier)
      delegate.appendMessage(Message(actionType: .reply, actor: replier, content: replyText))
    }

    // Filter
    computers.forEach { computer in
      computer.filter(repliers, by: question)
    }
  }
  
  func playerGuess(_ guess: CardSet) {
    print("\(human.name) guess \(guess)")
    self.guess(guess, by: human)
  }
  
  private func guess(_ guess: CardSet, by actor: Player) {
    let cards = guess.cards
    var guessText = ""
    for card in cards {
      let color = card.color.rawValue
      let number = card.number
      guessText += "\(color)\(number)、"
    }
    guessText.removeLast()
    delegate.appendMessage(Message(actionType: .guess, actor: actor, content: guessText))

    let target: CardSet
    if answer != nil {
      target = answer!
    } else {
      let opponent = players.first { $0 != actor }
      target = opponent!.cardSet
    }
    if guess == target {
      delegate.appendMessage(Message(normalText: "猜對了！"))
      // TODO: 2-player game verdict
      winner = actor
      shouldEnd = true
    } else {
      delegate.appendMessage(Message(normalText: "猜錯了！"))
      // TODO: call computer to record failure
    }
  }

  func ending() {
    if let winner = winner {
      delegate.appendMessage(Message(winner: winner))
    } else {
      delegate.appendMessage(Message(normalText: "無人獲勝。"))
    }
    delegate.appendMessage(Message(normalText: "遊戲結束。"))
  }

  private func reply(to question: Question, by player: Player) -> String {
    // Tools
    func reportPositions(of sequence: [Int]?) -> String {
      guard sequence != nil else {
        return "沒有。"
      }
      var result = "在第"
      for position in sequence! {
        result += "\(position + 1)、"
      }
      result.removeLast() // remove last "、"
      result += "位。"
      return result
    }
    func reportSequences(by method: () -> [[Int]]?) -> String {
      guard method() != nil else {
        return "沒有。"
      }
      let sequences = method()!
      let firstSequence = sequences[0]
      // TODO : fix "連續數字的卡牌在哪" bug
      var firstReport = reportPositions(of: firstSequence)
      if sequences.count > 1 {
        let secondSequence = sequences[1]
        var secondReport = reportPositions(of: secondSequence)
        firstReport.removeLast() // remove last "。"
        secondReport.removeFirst() // remove first "在"
        return "\(firstReport)和\(secondReport)"
      }
      return firstReport
    }

    var reply = ""
    let testee = player.cardSet
    switch question.id {
      case 0:
        // "所有紅色數字卡相加的總和是多少？"
        reply = "\(testee.sumOfColor(.red))。"
      case 1:
        // "所有藍色數字卡相加的總和是多少？"
        reply = "\(testee.sumOfColor(.blue))。"
      case 2:
        // "左邊三張數字卡相加的總和是多少？"
        reply = "\(testee.leftSum())。"
      case 3:
        // "右邊三張數字卡相加的總和是多少？"
        reply = "\(testee.rightSum())。"
      case 4:
        // "有幾對相同的數字卡？"
        reply = "\(testee.countOfPairs())對。"
      case 5:
        // "有幾張紅色數字卡？"
        reply = "\(testee.countOfColor(.red))張。"
      case 6:
        // "有幾張藍色數字卡？"
        reply = "\(testee.countOfColor(.blue))張。"
      case 7:
        // "有幾張奇數卡？"
        reply = "\(testee.countOfOdd())張。"
      case 8:
        // "有幾張偶數卡？"
        reply = "\(testee.countOfEven())張。"
      case 9:
        // "連續數字的卡片在哪幾個位置？"
        reply = reportSequences(by: testee.positionsOfSequentialNumber)
      case 10:
        // "顏色相同並且相鄰的數字卡在哪幾個位置？"
        reply = reportSequences(by: testee.positionsOfContiguousColor)
      case 11:
        // "數字1在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(1))
      case 12:
        // "數字2在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(2))
      case 13:
        // "數字3在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(3))
      case 14:
        // "數字4在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(4))
      case 15:
        // "數字5在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(5))
      case 16:
        // "數字6在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(6))
      case 17:
        // "數字7在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(7))
      case 18:
        // "數字8在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(8))
      case 19:
        // "數字9在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(9))
      case 20:
        // "數字0在哪個位置？"
        reply = reportPositions(of: testee.positionsOfNumber(0))
      case 21:
        // "所有數字卡相加的總和是多少？（共享）"
        reply = "\(testee.sum())。"
      case 22:
        // "最大的數字卡與最小的數字卡相差多少？（共享）"
        reply = "\(testee.difference())。"
      case 23:
        // "中間的數字卡大於4嗎？（共享）"
        reply = testee.isGreater(than: 4, at: 2) ? "是。" : "否。"
      case 24:
        // "中間三張數字卡相加的總和是多少？"
        reply = "\(testee.centerSum())。"
      default:
        print("Illegal question id!")
    }
    return reply
  }
}

// MARK: - GameManagerDelegate

protocol GameManagerDelegate {
  func appendMessage(_ message: Message)
  func didAskQuestion(at index: Int) 
}
