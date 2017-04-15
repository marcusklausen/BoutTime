//
//  GameFinishedViewController.swift
//  BoutTime
//
//  Created by howroot on 06/04/2017.
//  Copyright © 2017 Marcus Jepsen Klausen. All rights reserved.
//

import UIKit

// Delegate protocol, ViewController.swift conforms
protocol GameFinishedDelegate {
    func playAgainButtonPressed(_ playAgain: Bool)
}

class GameFinishedViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    // Play again pressed?
    @IBAction func playAgainButton(_ sender: Any) {
        
        // Dismiss
        dismiss(animated: true, completion: nil)
        
        // Run playAgainButtonPressed() method form ViewController.swift thanks to delegate
        delegate.playAgainButtonPressed(true)
    }
    
    // Set delegate to nil with this VC as type
    var delegate: GameFinishedDelegate! = nil
    
    // Initiate score
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set score for display
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
