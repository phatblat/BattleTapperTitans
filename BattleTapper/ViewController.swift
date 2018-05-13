//
//  ViewController.swift
//  BattleTapper
//
//  Created by Ben Chatelain on 5/13/18.
//  Copyright © 2018 Jack Chatelain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var progress: UIProgressView!
    @IBOutlet var level: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var creature: UIImageView!

    private let game = GameController()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    /// Updates the UI
    func updateUI() {
        creature.image = UIImage(named: "Evo\(game.currentLevel + 1)")
        level.text = game.currentLevelDisplay
        progress.progress = game.progress
    }

    /// Handler for the button tap
    @IBAction func incrementProgress(_ sender: Any) {
        if game.tap() && !game.active {
            // Game over
            endGame()
        }
        updateUI()
    }

    /// Announces the end of the game.
    func endGame() {
        // Disable the button
        button.isEnabled = false

        // Final BattleTapper
        creature.image = UIImage(named: "Evo15Final")

        let alert = UIAlertController(
            title: "Game Over",
            message: "You did it! It took you \(game.tapCount) taps to beat all \(game.currentLevel + 1) levels.",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .cancel) { (_: UIAlertAction) in
            alert.dismiss(animated:  true)
        }
        alert.addAction(action)

        present(alert, animated: true)
    }
}
