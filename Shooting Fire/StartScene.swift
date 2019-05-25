//
//  StartScene.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 24/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    var backgroundMusic: SKAudioNode!
    var gameScene:SKScene!
    var startButton: SKSpriteNode?
    
    override func didMove(to view: SKView) {
     
        if let musicURL = Bundle.main.url(forResource: "authormusic-drone-electronics-build-upc", withExtension: "mp3") {
                        backgroundMusic = SKAudioNode(url: musicURL)
                        addChild(backgroundMusic)
        }
        
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
        }
    }
}
