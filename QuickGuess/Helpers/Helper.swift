//
//  Helper.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/20.
//

import UIKit

class Helper {
  static func cardUIColor(of cardColor: CardColor) -> UIColor {
    switch cardColor {
    case .red:
      return UIColor.redCard
    case .blue:
      return UIColor.blueCard
    case .green:
      return UIColor.greenCard
    }
  }
}
