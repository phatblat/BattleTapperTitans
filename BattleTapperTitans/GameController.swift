//
//  GameController.swift
//  BattleTapper
//
//  Created by Ben Chatelain on 5/13/18.
//  Copyright © 2018 Jack Chatelain. All rights reserved.
//

import Foundation

class GameController {
    var active = true
    var playerWon: Bool?
    var currentLevel = 0
    var currentEnemy: Enemy!
    var elapsedSeconds = 0
    var tapCount = 0
    var timer: Timer?
    var observer: GameUpdateObserver?

    /// Number of seconds remaining for the current level.
    var remainingTime: Int { get {
        guard elapsedSeconds >= 0, currentEnemy.time > 0 else { return 0 }
        return Int(currentEnemy.time) - elapsedSeconds
    }}

    /// Percentage increase for each tap
    var timeProgress: Float { get {
        guard remainingTime > 0, currentEnemy.time > 0 else { return 0 }
        return Float(remainingTime) / currentEnemy.time
    }}

    /// Level displayed to user starts at 1
    var currentLevelDisplay: String { get {
        return "Level \(currentLevel + 1)"
    }}

    /// Array of Enemies
    var enemies: [Enemy] = []

    init() {
        enemies = loadGameData()
        guard let enemy = enemies.first else { fatalError("No enemies loaded from game data!") }
        currentEnemy = enemy
        startTimer()
    }

    /// Loads game data from plist file.
    ///
    /// - Returns: Array of Enemy
    func loadGameData() -> [Enemy] {
        guard let path = Bundle.main.path(forResource: "GameData", ofType: "plist"),
        let data = NSArray(contentsOfFile: path) as? [[String: Any]]
            else { fatalError("Unable to load GameData.plist") }

        var enemies: [Enemy] = []
        data.forEach { (raw: [String: Any]) in
            guard let name = raw["name"] as? String,
                  let health = raw["health"] as? Int,
                  let time = raw["time"] as? Float
            else {
                debugPrint("Error parsing enemy: \(raw)")
                return
            }

            let enemy = Enemy(name: name, totalHealth: health, currentHealth: health, time: time)
            debugPrint("Parsed enemy: \(enemy)")
            enemies.append(enemy)
        }

        return enemies
    }

    /// Starts the game from level 1 again.
    func replay() {
        active = true
        playerWon = nil
        currentLevel = 0
        currentEnemy = enemies.first
        elapsedSeconds = 0
        tapCount = 0
        startTimer()
        observer?.gameUpdated()
    }

    /// Restart the current level.
    func retryLevel() {
        active = true
        playerWon = nil
        elapsedSeconds = 0
        currentEnemy.currentHealth = currentEnemy.totalHealth
        startTimer()
        observer?.gameUpdated()
    }

    /// Attacks the current enemy.
    ///
    /// - Returns: true if the enemy was defeated; false otherwise.
    func attack() -> Bool {
        guard active else { return false }

        tapCount += 1
        if currentEnemy.hit() {
            debugPrint("Enemy is dead \(String(describing: currentEnemy))")
            nextLevel()
            return true
        }

        debugPrint("Enemy was hit \(String(describing: currentEnemy))")
        return false
    }

    /// Progress to the next level.
    func nextLevel() {
        debugPrint("Level \(currentLevel + 1) passed with \(remainingTime) seconds remaining.")

        // next level
        currentLevel += 1
        if currentLevel >= enemies.count {
            endGame()
            return
        }
        currentEnemy = enemies[currentLevel]
        debugPrint("Level \(currentLevel + 1) enemy: \(String(describing: currentEnemy))")
        resetTimer()
    }

    /// Ends the game.
    func endGame() {
        active = false
        stopTimer()
        debugPrint("Game completed with \(remainingTime) seconds remaining.")

        if playerWon == nil {
            playerWon = true
            debugPrint("Player won!")
        }
    }
}

/// Extension containing timer-related functionality.
extension GameController {
    /// Starts the timer for the current level.
    func startTimer() {
        elapsedSeconds = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }

    /// Stops the timer.
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    /// Cancels the current timer and starts a new one.
    func resetTimer() {
        stopTimer()
        startTimer()
    }

    /// Called each time the timer fires.
    @objc func timerFired() {
        elapsedSeconds += 1

        // Test if time ran out
        if remainingTime <= 0 {
            playerWon = false
            endGame()
            debugPrint("Game over. Time ran out with \(currentEnemy.currentHealth) enemy health remaining.")
        }

        observer?.gameUpdated()
    }
}
