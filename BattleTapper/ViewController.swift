//
//  ViewController.swift
//  BattleTapper
//
//  Created by Ben Chatelain on 5/13/18.
//  Copyright © 2018 Jack Chatelain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var healthProgress: UIProgressView!
    @IBOutlet var timeProgress: UIProgressView!
    @IBOutlet var level: UILabel!
    @IBOutlet var enemy: UILabel!
    @IBOutlet var button: UIButton!

    private let game = GameController()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    /// Updates the UI.
    func updateUI() {
        healthProgress.progress = game.currentEnemy.healthPercent
        healthProgress.tintColor = game.currentEnemy.healthColor
        timeProgress.progress = game.timeProgress
        level.text = game.currentLevelDisplay
        enemy.text = game.currentEnemy.name
    }

    /// Handler for the button tap.
    @IBAction func incrementProgress(_ sender: Any) {
        if game.attack() && !game.active {
            // Game over
            endGame()
        }
        updateUI()
    }

    /// Announces the end of the game.
    func endGame() {
        // Disable the button
        button.isEnabled = false

        let alert = UIAlertController(
            title: "Congrats!",
            message: "You beat BattleTapper!",
            preferredStyle: .alert
        )
        let quit = UIAlertAction(title: "Quit", style: .destructive) { _ in
            alert.dismiss(animated:  true)
        }
        let replay = UIAlertAction(title: "Replay", style: .cancel) { _ in
            alert.dismiss(animated:  true)
        }
        alert.addAction(quit)
        alert.addAction(replay)

        present(alert, animated: true)
    }
}
