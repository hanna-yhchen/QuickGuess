//
//  NoteViewController.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/24.
//

import UIKit

// MARK: - NoteViewController

class NoteViewController: UIViewController {
  @IBOutlet var cards: [UIButton]!
  @IBOutlet var textView: UITextView! {
    // tackle with CoreText issue (CTFontLogSystemFontNameRequest)
    didSet {
      textView.font = UIFont.systemFont(ofSize: 14)
    }
  }

  var playerCards: [Card]!
  let placeHolderText = "這裡可以做筆記⋯⋯"

  override func viewDidLoad() {
    super.viewDidLoad()

    textView.delegate = self
    textView.text = placeHolderText

    cards.sort()

    textView.textContainerInset = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)

    initializeDisplay()
  }

  @IBAction func cardSelected(_ sender: UIButton) {
    if sender.alpha == 1 {
      sender.alpha = 0.3
    } else {
      sender.alpha = 1
    }
  }

// TODO: adjust UI to accommodate a reset button
//  @IBAction func resetPressed(_: UIButton) {
//    for i in 0..<cards.count {
//      cards[i].alpha = 1
//    }
//    initializeDisplay()
//  }

  private func initializeDisplay() {
    for card in playerCards {
      let tag = card.id
      cards[tag].alpha = 0.3
      cards[tag].isEnabled = false
    }
  }
}

// MARK: - UITextViewDelegate

extension NoteViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == placeHolderText {
      textView.text = ""
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if !textView.hasText {
      textView.text = placeHolderText
    }
  }
}
