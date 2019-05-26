//
//  StartScene.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 24/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
   
    var gameScene:SKScene!
    var startButton: SKSpriteNode?
    var creditButton: SKSpriteNode?
    var backgroundNoise = SKAction.playSoundFileNamed("authormusic-drone-electronics-build-up.mp3", waitForCompletion: true)
    
    override func didMove(to view: SKView) {
     
    startButton = self.childNode(withName: "startButton") as? SKSpriteNode
    self.run(backgroundNoise)
    creditButton = self.childNode(withName: "creditButton") as? SKSpriteNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
        let location = touch.previousLocation(in: self)
        let node = self.nodes(at: location).first
            
            if node?.name == "startButton" {
                print("tap")
                let transition = SKTransition.fade(withDuration: 1)
                gameScene = SKScene(fileNamed: "GameScene")
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene, transition: transition)
                
            }
            
            else if node?.name == "creditButton" {
                let transition = SKTransition.fade(withDuration: 1)
                gameScene = SKScene(fileNamed: "CreditScene")
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene, transition: transition)
                
            }
        }
    }
}
