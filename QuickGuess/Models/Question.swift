//
//  Question.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/20.
//

import Foundation

struct Question {
  let id: Int
  let text: String

  init(_ id: Int) {
    self.id = id
    switch id {
      case 0:
        self.text = "所有紅色數字卡相加的總和是多少？"
      case 1:
        self.text = "所有藍色數字卡相加的總和是多少？"
      case 2:
        self.text = "左邊三張數字卡相加的總和是多少？"
      case 3:
        self.text = "右邊三張數字卡相加的總和是多少？"
      case 4:
        self.text = "有幾對相同的數字卡？"
      case 5:
        self.text = "有幾張紅色數字卡？"
      case 6:
        self.text = "有幾張藍色數字卡？"
      case 7:
        self.text = "有幾張奇數卡？"
      case 8:
        self.text = "有幾張偶數卡？"
      case 9:
        self.text = "連續數字的卡片在哪幾個位置？"
      case 10:
        self.text = "顏色相同並且相鄰的數字卡在哪幾個位置？"
      case 11:
        self.text = "數字 1 在哪個位置？"
      case 12:
        self.text = "數字 2 在哪個位置？"
      case 13:
        self.text = "數字 3 在哪個位置？"
      case 14:
        self.text = "數字 4 在哪個位置？"
      case 15:
        self.text = "數字 5 在哪個位置？"
      case 16:
        self.text = "數字 6 在哪個位置？"
      case 17:
        self.text = "數字 7 在哪個位置？"
      case 18:
        self.text = "數字 8 在哪個位置？"
      case 19:
        self.text = "數字 9 在哪個位置？"
      case 20:
        self.text = "數字 0 在哪個位置？"
      case 21:
        self.text = "所有數字卡相加的總和是多少？（共享）"
      case 22:
        self.text = "最大的數字卡與最小的數字卡相差多少？（共享）"
      case 23:
        self.text = "中間的數字卡大於4嗎？（共享）"
      case 24:
        self.text = "中間三張數字卡相加的總和是多少？"
      default:
        self.text = ""
        print("Illegal question id!")
    }
  }
}
