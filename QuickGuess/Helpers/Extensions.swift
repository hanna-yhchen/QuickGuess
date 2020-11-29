//
//  Extensions.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/20.
//

import UIKit

// MARK: - UIColor

// Custom UIColor
extension UIColor {
  static let redCard = UIColor(named: "redCard")!
  static let blueCard = UIColor(named: "blueCard")!
  static let greenCard = UIColor(named: "greenCard")!
  static let normalText = UIColor(named: "ivory")!
  static let highlightText = UIColor(named: "red")!
  static let nameText = UIColor(named: "yellow")!
  static let questionCard = UIColor(named: "bluePalette-3")
  static let questionCardBack = UIColor(named: "bluePalette-1")
}

// MARK: - UIView + Comparable

// Enable UIViews to be sorted by tag
extension UIView: Comparable {
  public static func < (lhs: UIView, rhs: UIView) -> Bool {
    return lhs.tag < rhs.tag
  }
}

@IBDesignable
extension UIView {
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  @IBInspectable var borderWidthDivider: CGFloat {
    get {
      return frame.height / layer.borderWidth
    }
    set {
      layer.borderWidth = frame.height / newValue
    }
  }
  
  @IBInspectable var cornerRadiusDivider: CGFloat {
    get {
      return frame.height / layer.cornerRadius
    }
    set {
      layer.cornerRadius = frame.height / newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
}

// MARK: - UIViewController

// Alert tool
extension UIViewController {
  func showAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "取消", style: .cancel))
    alert.addAction(UIAlertAction(title: "確認", style: .destructive, handler: handler))
    present(alert, animated: true)
  }
}
