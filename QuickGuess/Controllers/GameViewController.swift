//
//  GameViewController.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/20.
//

import UIKit

// MARK: - GameViewController

class GameViewController: UIViewController {
  @IBOutlet var messageTableView: UITableView!
  @IBOutlet var operationView: UIView!
  @IBOutlet var operationViews: [UIView]!
  @IBOutlet var segmentedControl: UISegmentedControl!
  @IBOutlet var playerCardLabels: [UILabel]!

  var numberOfPlayers: Int!
  var gameManager: GameManager!
  var questionVC: QuestionViewController!

  var messages = [Message]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    operationViews.sort()
    playerCardLabels.sort()

    operationView.isUserInteractionEnabled = false

    messageTableView.dataSource = self
    messageTableView.register(
      UINib(nibName: K.messageCellNibName, bundle: nil),
      forCellReuseIdentifier: K.messageCellIdentifier)

    segmentedControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16)], for: .normal)

    startGame()
  }

  override func shouldPerformSegue(withIdentifier identifier: String, sender _: Any?) -> Bool {
    if identifier == K.infoSegue {
      return true
    }
    return false
  }

  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    if segue.identifier == K.questionSegue {
      questionVC = segue.destination as? QuestionViewController
      questionVC.delegate = self
    }
    if segue.identifier == K.guessSegue {
      let guessVC = segue.destination as? GuessViewController
      guessVC?.delegate = self
      guessVC?.playerCards = gameManager.playerCards()
    }
    if segue.identifier == K.noteSegue {
      let noteVC = segue.destination as? NoteViewController
      noteVC?.playerCards = gameManager.playerCards()
    }
  }
}

// MARK: - Actions

extension GameViewController {
  @IBAction func backPressed(_: UIButton) {
    showAlert(title: nil, message: "開始新遊戲？") { _ in
      self.performSegue(withIdentifier: K.backSegue, sender: self)
    }
  }
  
  @IBAction func switchSegment(_ sender: UISegmentedControl) {
    for view in operationViews {
      view.isHidden = true
      if view.tag == sender.selectedSegmentIndex {
        view.isHidden = false
      }
    }
  }
}

// MARK: - Methods

extension GameViewController {
  func startGame() {
    // Setup game manager
    gameManager = GameManager(numberOfPlayers: numberOfPlayers)
    gameManager.delegate = self
    gameManager.setup()

    // Setup player's card view
    let cards = gameManager.playerCards()
    if cards.count == 4 {
      playerCardLabels[4].isHidden = true
    }
    for (index, card) in cards.enumerated() {
      let cardText = String(card.number)
      let cardColor = Helper.cardUIColor(of: card.color)
      let cardLabel = playerCardLabels[index]
      cardLabel.attributedText = NSAttributedString(
        string: cardText,
        attributes: [.foregroundColor: cardColor])
    }

    // Setup embedded views
    performSegue(withIdentifier: K.questionSegue, sender: self)
    questionVC.setupQuestions(gameManager.questionHolders)
    performSegue(withIdentifier: K.noteSegue, sender: self)
    performSegue(withIdentifier: K.guessSegue, sender: self)

    // Openning messages
    gameManager.openning()
    updateMessages()
    delayToCall(nextTurn, after: 0.5)
  }

  func nextTurn() {
    operationView.isUserInteractionEnabled = false
    
    guard gameManager.isAnyQuestionAvailable() else {
      messages.append(Message(normalText: "問題卡耗盡。"))
      endGame()
      return
    }
    
    let actor = gameManager.nextPlayer()
    messages.append(Message(turnTo: actor))
    if actor is Computer {

      // Turn to computer
      gameManager.turn(to: actor as! Computer)
      updateMessages()
      
      if gameManager.shouldEnd {
        delayToCall(endGame, after: 0.5)
      } else {
        delayToCall(nextTurn, after: 1.0)
      }
    } else {
      // Turn to player
      updateMessages()
      operationView.isUserInteractionEnabled = true
    }
    
  }
  
  func endGame() {
    gameManager.ending()
    updateMessages()
    delayToCall({
      self.showAlert(title: "遊戲結束", message: "再來一局嗎？") { _ in
        self.performSegue(withIdentifier: K.backSegue, sender: self)
      }
    }, after: 1.0)
  }
  
  func delayToCall(_ method: @escaping () -> Void, after second: Double) {
    DispatchQueue.main.asyncAfter(deadline: .now() + second) {
      method()
    }
  }

  func updateMessages() {
    messageTableView.reloadData()
    // Scroll to bottom
    let bottom = messageTableView.numberOfRows(inSection: 0) - 1
    messageTableView.scrollToRow(
      at: IndexPath(row: bottom, section: 0),
      at: .bottom,
      animated: true)
  }

  func attributedString(of message: Message) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString()
    for section in message.sections {
      attributedString
        .append(NSAttributedString(
          string: section.text,
          attributes: [.foregroundColor: section.color]))
    }
    return attributedString
  }
}

// MARK: - UITableViewDataSource

extension GameViewController: UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return messages.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: K.messageCellIdentifier,
      for: indexPath) as! MessageTableViewCell
    let message = messages[indexPath.row]
    cell.label.attributedText = attributedString(of: message)
    return cell
  }
}

// MARK: - GameManagerDelegate

extension GameViewController: GameManagerDelegate {
  
  func appendMessage(_ message: Message) {
    messages.append(message)
  }

  func didAskQuestion(at index: Int) {
    questionVC.pickingQuestion(at: index)
  }
}

// MARK: - QuestionVCDelegate

extension GameViewController: QuestionVCDelegate {
  func nextQuestion(at index: Int) -> Question? {
    return gameManager.nextQuestion(at: index)
  }

  func didPickQuestion(at index: Int) {
    gameManager.playerAsk(at: index)
    updateMessages()
    delayToCall(nextTurn, after: 1.0)
  }
}


extension GameViewController: GuessVCDelegate {
  func didGuess(_ guess: CardSet) {
    gameManager.playerGuess(guess)
    updateMessages()
    if gameManager.shouldEnd {
      delayToCall(endGame, after: 0.5)
    } else {
      delayToCall(nextTurn, after: 1.0)
    }
  }
}
