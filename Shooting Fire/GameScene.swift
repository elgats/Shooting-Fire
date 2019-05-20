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
        var currentTrack = 0
        var musicSetting: Bool = true
        let fireSound = SKAction.playSoundFileNamed("flameloop.wav", waitForCompletion: true)
    
        //let soundtrack = SKAction.playSoundFileNamed("POL-sage-rage-short.wav", waitForCompletion: true)
        let shotSound = SKAction.playSoundFileNamed("flamethrowerwav.wav", waitForCompletion: false)
        var moveTrack = false
    
    enum shapes {
        case target
        case notTarget
    }
    
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
        //let angrySound:SKAction = SKAction.repeatForever(soundtrack)
        //self.run(angrySound)
        
    }
    
    func move (pindah: Bool) {
        if pindah {
        let moving = SKAction.moveBy(x: 15, y: 0, duration: 0.1)
        let repeatAction = SKAction.repeatForever(moving)
            
            if ((fire?.position.x)!) <= UIScreen.main.bounds.maxX {
            fire?.run(repeatAction, withKey: "moveRight")
            }
            
            else {
                fire?.removeAction(forKey: "moveRight")
            }
//            fire?.run(repeatAction, withKey: "moveRight")
//
//            if (fire?.position.x) == UIScreen.main.bounds.maxX {
//                fire?.removeAction(forKey: "moveRight")
//            }
//            else {
//                fire?.run(repeatAction)
//            }
        }
        
        else {
            let moving = SKAction.moveBy(x: -15, y: 0, duration: 0.1)
            let repeatAction = SKAction.repeatForever(moving)
            fire?.run(repeatAction)
            
            if ((fire?.position.x)!) <= UIScreen.main.bounds.minX {
                fire?.run(repeatAction, withKey: "moveLeft")
            }
                
            else {
                fire?.removeAction(forKey: "moveLeft")
            }
        }
    }
        
    func shoot() {
        //fire?.removeAllActions()
        moveTrack = true
        
            if let fire = self.fire {
            let shooting = SKAction.moveBy(x: 0, y: 3000, duration: 2)
//            let repeatAction = SKAction.repeatForever(shooting)
                fire.run(shooting, completion: {self.moveTrack = false})
                
            self.run(shotSound)
                
            createFire()
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
    
    func createShapes (type: shapes, forTrack track: Int) -> SKShapeNode? {
        let shapeSprite = SKShapeNode()
        
        switch type {
        case .target:
            shapeSprite.path = CGPath(roundedRect: CGRect(x: -10, y: 0, width: 30, height: 30), cornerWidth: 20, cornerHeight: 20, transform: nil)
            shapeSprite.fillColor = UIColor.red
            
        case .notTarget:
            CGPath(roundedRect: CGRect(x: -10, y: 0, width: 30, height: 30), cornerWidth: 20, cornerHeight: 20, transform: nil)
            shapeSprite.fillColor = UIColor.green
        }
        
//        guard let shapePosition = tracksArray?[track].position else {return nil}
        return shapeSprite
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
            else if node?.name == "api" {
                shoot()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !moveTrack {
            
            fire?.removeAllActions()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        fire?.removeAllActions()
    }
    
}
