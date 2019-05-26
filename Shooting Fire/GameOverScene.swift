//
//  GameOverScene.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 24/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let evilSound = SKAction.playSoundFileNamed("Evil_Laugh_Male_6-Himan-1359990674.wav", waitForCompletion: true)
    
//    
    override func didMove(to view: SKView) {
        
        self.run(evilSound)
//        
//        }
        
    }
    
}
