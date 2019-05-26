//
//  CreditScene.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 26/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit

class CreditScene: SKScene {
    
    var playButton: SKSpriteNode?
    var gameScene:SKScene!
    
    override func didMove(to view: SKView) {
        
        playButton = self.childNode(withName: "playButton") as? SKSpriteNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            if node?.name == "playButton" {
                print("tap")
                let transition = SKTransition.fade(withDuration: 1)
                gameScene = SKScene(fileNamed: "GameScene")
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene, transition: transition)
                
            }
            
        }
    }
}
