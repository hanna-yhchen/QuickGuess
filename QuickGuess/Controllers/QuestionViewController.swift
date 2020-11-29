//
//  QuestionViewController.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/22.
//

import UIKit

// MARK: - QuestionViewController

class QuestionViewController: UIViewController {
  @IBOutlet var questionViews: [UIView]!
  @IBOutlet var questionButtons: [UIButton]!

  var delegate: QuestionVCDelegate!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Sort by tag
    questionButtons.sort()
    questionViews.sort()


    for button in questionButtons {
      button.titleLabel?.numberOfLines = 0
      button.titleLabel?.textAlignment = .center
      button.titleLabel?.adjustsFontSizeToFitWidth = true
      button.titleLabel?.minimumScaleFactor = 0.5
      button.titleLabel?.insetsLayoutMarginsFromSafeArea = true
    }
    
  }

  @IBAction func buttonPressed(_ sender: UIButton) {
    let index = sender.tag
    let text = sender.currentTitle
    showAlert(title: "提問", message: text) { _ in
      self.delegate.didPickQuestion(at: index)
    }
  }

  func setupQuestions(_ questions: [Question?]) {
    for i in 0..<6 {
      questionButtons[i].setTitle(questions[i]?.text, for: .normal)
    }
  }
}

// MARK: - Methods

extension QuestionViewController {
  func pickingQuestion(at index: Int) {
    let questionView = questionViews[index]
    let questionButton = questionButtons[index]
    questionView.backgroundColor = UIColor.questionCardBack

    if let nextQuestion = delegate.nextQuestion(at: index) {
      UIView.transition(
        with: questionView,
        duration: 0.8,
        options: .transitionFlipFromLeft,
        animations: {
          questionButton.setTitle("", for: .normal)
        },
        completion: { _ in
          UIView.transition(
            with: questionView,
            duration: 0.8,
            options: .transitionCrossDissolve,
            animations: {
              questionButton.setTitle(nextQuestion.text, for: .normal)
              questionView.backgroundColor = UIColor.questionCard
            },
            completion: nil)
        })
    } else {
      questionButton.isEnabled = false

      UIView.transition(
        with: questionView,
        duration: 0.8,
        options: .transitionFlipFromLeft,
        animations: {
          questionButton.setTitle("", for: .normal)
        },
        completion: nil)
    }
  }
}

// MARK: - QuestionVCDelegate

protocol QuestionVCDelegate {
  func nextQuestion(at index: Int) -> Question?
  func didPickQuestion(at index: Int)
}
