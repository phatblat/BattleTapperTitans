//
//  Enemy.swift
//  BattleTapper
//
//  Created by Ben Chatelain on 5/13/18.
//  Copyright © 2018 Jack Chatelain. All rights reserved.
//

import UIKit
import Foundation

struct Enemy {
    /// Display name
    let name: String

    /// Starting health
    let totalHealth: Int

    /// Current health
    var currentHealth: Int

    /// Number of seconds user has to beat enemy
    let time: Float
}

extension Enemy {
    /// Percent of total health remaining
    var healthPercent: Float { get {
        guard totalHealth > 0 else { return 0 }
        return Float(currentHealth) / Float(totalHealth)
    }}

    /// Color to display on the enemy's health bar.
    var healthColor: UIColor { get {
        switch healthPercent {
        case let it where it < 0.25:
            return .red
        case let it where it < 0.50:
            return .yellow
        default:
            return .green
        }
    }}

    /// Flag indicating whether the enemy is dead or not
    var isDead: Bool { get {
        guard totalHealth > 0, currentHealth > 0 else { return true }
        return false
    }}

    /// Hit the enemy.
    ///
    /// - Returns: true if the enemy is dead; false otherwise
    mutating func hit() -> Bool {
        guard currentHealth > 0 else { return true }
        currentHealth -= 1
        return isDead
    }
}
