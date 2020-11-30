//
//  InfoViewController.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/28.
//

import UIKit

class InfoViewController: UIViewController {
  @IBOutlet var textView: UITextView! {
    didSet {
      textView.textColor = UIColor.normalText
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func dismissPressed(_: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}
