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
    var progress: Float = 0.0
    var tapCount = 0

    /// Level displayed to user starts at 1
    var currentLevelDisplay: String { get {
        return "Level \(currentLevel + 1)"
    }}

    /// Array of number of taps to pass each level
    var levelDifficulty: [Int] = []

    /// Percentage increase for each tap
    var currentLevelIncrementAmount: Float { get {
        return 1 / Float(levelDifficulty[currentLevel])
    }}

    init() {
        levelDifficulty = loadGameData()
    }

    func loadGameData() -> [Int] {
        guard let path = Bundle.main.path(forResource: "GameData", ofType: "plist"),
            let data = NSArray.init(contentsOfFile: path) as? [Int]
            else { fatalError("Unable to load GameData.plist") }

        return data
    }

    /// Increments the progress.
    ///
    /// - Returns: true if the level was completed; false otherwise
    func tap() -> Bool {
        guard active else { return false }

        tapCount += 1
        progress += currentLevelIncrementAmount
        debugPrint("progress increased to \(progress)")

        if progress >= 1 {
            if currentLevel == levelDifficulty.count - 1 {
                active = false
                return true
            }
            // next level
            currentLevel += 1
            progress = 0.0
            return true
        }
        return false
    }
}
