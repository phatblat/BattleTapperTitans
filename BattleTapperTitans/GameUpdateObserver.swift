//
//  GameUpdateObserver.swift
//  BattleTapper
//
//  Created by Ben Chatelain on 5/13/18.
//  Copyright © 2018 Jack Chatelain. All rights reserved.
//

import Foundation

protocol GameUpdateObserver {
    /// Called to inform observers that the game has been updated.
    func gameUpdated()
}
