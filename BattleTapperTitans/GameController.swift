//
//  GameController.swift
//  BattleTapperTitans
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
    var tapCount = 0
    var observer: GameUpdateObserver?

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

    /// Loads game data from plist file.
    ///
    /// - Returns: Array of Enemy
    func loadGameData() -> [Enemy] {
        guard let path = Bundle.main.path(forResource: "GameData", ofType: "plist"),
        let data = NSDictionary(contentsOfFile: path) as? [String: [[String: Any]]],
            let enemyData = data["enemies"]
            else { fatalError("Unable to load GameData.plist") }

        var enemies: [Enemy] = []
        enemyData.forEach { (raw: [String: Any]) in
            guard let name = raw["name"] as? String,
                  let emoji = raw["emoji"] as? String,
                  let health = raw["health"] as? Int
            else {
                debugPrint("Error parsing enemy: \(raw)")
                return
            }

            let enemy = Enemy(name: name, emoji: emoji, totalHealth: health, currentHealth: health)
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
        tapCount = 0
        observer?.gameUpdated()
    }

    /// Restart the current level.
    func retryLevel() {
        active = true
        playerWon = nil
        currentEnemy.currentHealth = currentEnemy.totalHealth
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
        debugPrint("Level \(currentLevel + 1) passed.")

        // next level
        currentLevel += 1
        if currentLevel >= enemies.count {
            endGame()
            return
        }
        currentEnemy = enemies[currentLevel]
        debugPrint("Level \(currentLevel + 1) enemy: \(String(describing: currentEnemy))")
    }

    /// Ends the game.
    func endGame() {
        active = false
        debugPrint("Game completed.")

        if playerWon == nil {
            playerWon = true
            debugPrint("Player won!")
        }
    }
}
