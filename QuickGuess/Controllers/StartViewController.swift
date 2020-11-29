//
//  StartViewController.swift
//  QuickGuess
//
//  Created by Hanna Chen on 2020/11/19.
//

import UIKit

class StartViewController: UIViewController {
  @IBOutlet var numberLabel: UILabel!
  @IBOutlet var startButton: UIButton!
  @IBOutlet var titleLabel: UILabel!
  
  var numberOfPlayers = 2
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
  }

  @IBAction func stepperChanged(_ sender: UIStepper) {
    let number = String(format: "%.f", sender.value)
    numberLabel.text = number
    
  }
  
  // TODO: start new game or continue unfinished game
  @IBAction func startPressed(_: UIButton) {
    numberOfPlayers = Int(numberLabel.text!)!
    performSegue(withIdentifier: K.startSegue, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let GameVC = segue.destination as! GameViewController
    GameVC.numberOfPlayers = numberOfPlayers
  }
  
}
