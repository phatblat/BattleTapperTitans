//
//  ViewController.swift
//  BattleTapperTitans
//
//  Created by Ben Chatelain on 5/13/18.
//  Copyright © 2018 Jack Chatelain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var endLevelBarButtonItem: UIBarButtonItem! { didSet {
        endLevelBarButtonItem.image = UIImage(named: "Sword")?.withRenderingMode(.alwaysOriginal)
    }}
    @IBOutlet var healthProgress: UIProgressView!
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
        level.text = game.currentLevelDisplay
        enemy.text = game.currentEnemy.name
        button.setTitle(game.currentEnemy.emoji, for: UIControl.State.normal) 
    }

    /// Handler for the attack button tap.
    @IBAction func incrementProgress(_ sender: Any) {
        if game.attack() && !game.active {
            // Game over
            guard let playerWon = game.playerWon else { fatalError("Game over but playerWon wasn't set!") }
            endGame(playerWon)
        }
        updateUI()
    }

    /// Handler for the defeat enemy button tap.
    @IBAction func nextLevel(_ sender: Any) {
        game.nextLevel()
        updateUI()
    }

    /// Announces the end of the game.
    func endGame(_ playerWon: Bool) {
        // Disable the button
        button.isEnabled = false

        let title: String
        let message: String
        let alert: UIAlertController
        let playAgain: UIAlertAction

        switch playerWon {
        case true:
            title = "Congrats!"
            message = "You beat BattleTapperTitans!"
            alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            playAgain = UIAlertAction(title: "Replay", style: .cancel) { [weak self] _ in
                alert.dismiss(animated: true)
                self?.replay()
            }
        case false:
            title = "You Lose"
            message = "Your time ran out. Would you like to retry the level?"
            alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            playAgain = UIAlertAction(title: "Retry", style: .cancel) { [weak self] _ in
                alert.dismiss(animated: true)
                self?.retryLevel()
            }
        }

        let quit = UIAlertAction(title: "Quit", style: .destructive) { _ in
            alert.dismiss(animated: true)
            abort()
        }
        alert.addAction(playAgain)
        alert.addAction(quit)

        present(alert, animated: true)
    }

    /// Starts the game over at level 1.
    func replay() {
        game.replay()

        // Enable the button
        button.isEnabled = true
    }

    /// Restarts the current level.
    func retryLevel() {
        game.retryLevel()

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
