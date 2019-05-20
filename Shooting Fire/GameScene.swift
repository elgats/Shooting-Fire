//
//  GameScene.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 20/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
//        var tracksArray: [SKSpriteNode]? = [SKSpriteNode]() //() for initilizing tracks
        var fire: SKSpriteNode?
        var musicSetting: Bool = true
        let fireSound = SKAction.playSoundFileNamed("flameloop.wav", waitForCompletion: true)
    
        let soundtrack = SKAction.playSoundFileNamed("POL-sage-rage-short.wav", waitForCompletion: true)
        var moveTrack = false
//    func setUpTracks() {
//
//        for i in 0 ... 1 {
//            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
//                tracksArray?.append(track)
//            }
//        }
//        tracksArray?.first?.color = UIColor.white
//
//    }
    
    override func didMove(to view: SKView) {
        
        createFire()
        sound()
        
        }

    func sound() {
        let loopSound:SKAction = SKAction.repeatForever(fireSound)
        self.run(loopSound)
        let angrySound:SKAction = SKAction.repeatForever(soundtrack)
        self.run(angrySound)
        
    }
    
    func move (pindah: Bool) {
        if pindah {
        let moving = SKAction.moveBy(x: 160, y: 0, duration: 0.5)
        let repeatAction = SKAction.repeatForever(moving)
        fire?.run(repeatAction)
        }
        
        else {
            let moving = SKAction.moveBy(x: -160, y: 0, duration: 0.5)
            let repeatAction = SKAction.repeatForever(moving)
            fire?.run(repeatAction)
        }
        
        func shoot (shot: Bool) {
            
        }
        
    }
//    func angryMusic() {
//
//        if musicSetting == true {
//            let angrySound:SKAction = SKAction.repeatForever(soundtrack)
//            self.run(angrySound)
//        }
//
//        else {
//            angrySound.removeAllActions()
//        }
//
//    }
    

    func createFire() {
        fire = SKSpriteNode(imageNamed: "Fire")
        
        fire?.position = CGPoint(x:325, y: 335)
        animateFire()
        self.addChild(fire!)
    }
    
    func animateFire() {
        let flame = SKEmitterNode(fileNamed: "FireParticle")!
        
        fire!.addChild(flame)
        flame.position = CGPoint(x: 0, y: -50)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            if node?.name == "left" {
                move(pindah: false)
            }
            else if node?.name == "right" {
                move(pindah: true)
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !moveTrack {
            
            fire?.removeAllActions()
        }
    }
    
}
