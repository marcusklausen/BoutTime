//
//  GameFinishedViewController.swift
//  BoutTime
//
//  Created by howroot on 06/04/2017.
//  Copyright © 2017 Marcus Jepsen Klausen. All rights reserved.
//

import UIKit

protocol GameFinishedDelegate {
    func playAgainButtonPressed(_ playAgain: Bool)
}

class GameFinishedViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBAction func playAgainButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate.playAgainButtonPressed(true)
    }
    

    
    var delegate:GameFinishedDelegate! = nil
    
    var score: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "\(score)/6"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
