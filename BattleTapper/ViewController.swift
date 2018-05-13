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
        game.observer = self
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
            guard let playerWon = game.playerWon else { fatalError("Game over but playerWon wasn't set!") }
            endGame(playerWon)
        }
        updateUI()
    }

    /// Announces the end of the game.
    func endGame(_ playerWon: Bool) {
        // Disable the button
        button.isEnabled = false

        let title: String
        let message: String

        switch playerWon {
        case true:
            title = "Congrats!"
            message = "You beat BattleTapper!"
        case false:
            title = "You Lose"
            message = "Your time ran out."
        }

        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let quit = UIAlertAction(title: "Quit", style: .destructive) { _ in
            alert.dismiss(animated:  true)
            abort()
        }
        let replay = UIAlertAction(title: "Replay", style: .cancel) { [weak self] _ in
            alert.dismiss(animated:  true)
            self?.replay()
        }
        alert.addAction(quit)
        alert.addAction(replay)

        present(alert, animated: true)
    }

    /// Starts the game over at level 1.
    func replay() {
        game.replay()
        
        // Enable the button
        button.isEnabled = true
    }
}

/// Implement observer protocol
extension ViewController: GameUpdateObserver {
    func gameUpdated() {
        if let playerWon = game.playerWon {
            // Timer ran out
            endGame(playerWon)
        }
        updateUI()
    }
}
