//
//  GameHandler.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 26/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import Foundation


class GameHandler {
    var timeResult: Int
    
    class var sharedInstance:GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        
        return Singleton.instance
    }
    
    init() {
        timeResult = 0
    }
}
