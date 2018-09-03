//
//  EnemyTests.swift
//  BattleTapperTitans
//
//  Created by Ben Chatelain on 9/3/18.
//  Copyright © 2018 Jack Chatelain. All rights reserved.
//

import XCTest
@testable import BattleTapperTitans

class EnemyTests: XCTestCase {
    var enemy: Enemy!
    override func setUp() {
        super.setUp()
        enemy = Enemy(name: "enemy", emoji: "👽", totalHealth: 10, currentHealth: 1)
    }

    override func tearDown() {
        super.tearDown()
        enemy = nil
    }

    func testHealthPercentIsTen() {
        XCTAssertEqual(enemy.healthPercent, 0.1)
    }

    func testIsAlive() {
        XCTAssertFalse(enemy.isDead)
    }

    func testIsDead() {
        XCTAssertTrue(enemy.hit())
        XCTAssertTrue(enemy.isDead)
    }

    func testHitWhileDead() {
        enemy.currentHealth = 0
        XCTAssertTrue(enemy.isDead)
        XCTAssertTrue(enemy.hit())
        XCTAssertTrue(enemy.isDead)
        XCTAssertEqual(enemy.currentHealth, 0)
    }

    func testHitWithOneHealth() {
        enemy.currentHealth = 1
        XCTAssertFalse(enemy.isDead)
        XCTAssertTrue(enemy.hit())
        XCTAssertTrue(enemy.isDead)
        XCTAssertEqual(enemy.currentHealth, 0)
    }

    func testHitWithTwoHealth() {
        enemy.currentHealth = 2
        XCTAssertFalse(enemy.isDead)
        XCTAssertFalse(enemy.hit())
        XCTAssertFalse(enemy.isDead)
        XCTAssertEqual(enemy.currentHealth, 1)
    }

    func testHit100WithTwoHealth() {
        XCTAssertFalse(enemy.isDead)
        XCTAssertTrue(enemy.hit(damage: 100))
        XCTAssertTrue(enemy.isDead)
        XCTAssertEqual(enemy.currentHealth, 0)
    }
}
