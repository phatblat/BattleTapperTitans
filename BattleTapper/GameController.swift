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
    var currentLevel = 0
    var currentEnemy: Enemy!
    var elapsedSeconds = 0
    var tapCount = 0

    /// Percentage increase for each tap
    var timeProgress: Float { get {
        guard elapsedSeconds > 0, currentEnemy.time > 0 else { return 0 }
        let time = currentEnemy.time
        return (time - Float(elapsedSeconds)) / time
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
    }

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

    /// Starts the timer for the current level.
    func startLevel() {}

    /// Stops the timer.
    func stopTimer() {}

    /// Attacks the current enemy.
    ///
    /// - Returns: true if the enemy was defeated; false otherwise.
    func attack() -> Bool {
        guard active else { return false }

        tapCount += 1
        if currentEnemy.hit() {
            debugPrint("Enemy is dead \(currentEnemy)")
            nextLevel()
            return true
        }

        debugPrint("Enemy was hit \(currentEnemy)")
        return false
    }

    /// Progress to the next level.
    func nextLevel() {
        // next level
        currentLevel += 1
        if currentLevel >= enemies.count {
            debugPrint("Game over, player has won with \(Int(currentEnemy.time) - elapsedSeconds) seconds remaining in level \(currentLevel + 1)")
            endGame()
            return
        }
        currentEnemy = enemies[currentLevel]
    }

    /// Ends the game.
    func endGame() {
        active = false
        stopTimer()
    }
}
