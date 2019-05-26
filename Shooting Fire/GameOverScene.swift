//
//  GameOverScene.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 24/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var gameScene:SKScene!
    var playAgainButton: SKSpriteNode?
    
    let evilSound = SKAction.playSoundFileNamed("Evil_Laugh_Male_6-Himan-1359990674.wav", waitForCompletion: true)
    
    
    override func didMove(to view: SKView) {
        
        self.run(evilSound)

        playAgainButton = self.childNode(withName: "playAgain") as? SKSpriteNode
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            if node?.name == "playAgain" {
                print("tap")
                let transition = SKTransition.fade(withDuration: 1)
                gameScene = SKScene(fileNamed: "GameScene")
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene, transition: transition)
                
            }
            
        }
    }
    
}
