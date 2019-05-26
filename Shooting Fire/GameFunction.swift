//
//  GameFunction.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 22/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    

    func move (node: SKSpriteNode, pindah: Bool) {
        if pindah {
            let moving = SKAction.moveBy(x: 15, y: 0, duration: 0.1)
            let repeatAction = SKAction.repeatForever(moving)
            
            if node.position.x <= 500 {
                node.run(repeatAction, withKey: "moveRight")
            }
            else if node.position.x > 500 {
                node.removeAction(forKey: "moveRight")
            }
           
        }
            
        else {
            let moving = SKAction.moveBy(x: -15, y: 0, duration: 0.1)
            let repeatAction = SKAction.repeatForever(moving)
           // fire?.run(repeatAction)
            
            if node.position.x >= 220 {
                node.run(repeatAction, withKey: "moveLeft")
            }
                
            else {
                node.removeAction(forKey: "moveLeft")
            }
        }
    }
    
//    func movingCalm (pindah: Bool) {
//        if pindah {
//            let moving = SKAction.moveBy(x: 15, y: 0, duration: 0.1)
//            let repeatAction = SKAction.repeatForever(moving)
//            
//            if (calm?.position.x)! <= CGFloat(500) {
//                calm?.run(repeatAction, withKey: "moveRight")
//            }
//            else if ((calm?.position.x)!) > 500 {
//                calm?.removeAction(forKey: "moveRight")
//            }
//        }
//        
//        else {
//            let moving = SKAction.moveBy(x: -15, y: 0, duration: 0.1)
//            let repeatAction = SKAction.repeatForever(moving)
//        
//        if ((calm?.position.x)!) >= 220 {
//            calm?.run(repeatAction, withKey: "moveLeft")
//        }
//            
//        else {
//            calm?.removeAction(forKey: "moveLeft")
//        }
//        }
//    }
    
    func moveCalmButton(show: Bool) {
        if show {
        self.childNode(withName: "leftCalm")?.isHidden = false
        self.childNode(withName: "rightCalm")?.isHidden = false
        self.childNode(withName: "left")?.isHidden = true
        self.childNode(withName: "right")?.isHidden = true
        }
        
        else {
        self.childNode(withName: "leftCalm")?.isHidden = true
        self.childNode(withName: "rightCalm")?.isHidden = true
        self.childNode(withName: "left")?.isHidden = false
        self.childNode(withName: "right")?.isHidden = false
        }
    }
    
    func shoot() {

        self.run(shotSound)

        let projectile = SKSpriteNode(imageNamed: "Particle")
        projectile.position = fire!.position
        let flame = SKEmitterNode(fileNamed: "FireParticle")!
        projectile.addChild(flame)
        flame.position = CGPoint(x: 0, y: -50)
        //  }
        let offset = CGPoint(x: (fire?.position.x)!, y: 3000)
        addChild(projectile)
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width)
        projectile.physicsBody?.linearDamping = 0
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = projectileCategory
        projectile.physicsBody?.collisionBitMask = 0
        projectile.physicsBody?.contactTestBitMask = targetCategory | notTargetCategory
        projectile.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func spawnShapes() {
        
        for i in 0 ... 3 { //4 = number of tracks
            let randomShapeType = shapes(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 2))!
            if let newShape = createShapes(type: randomShapeType, forTrack: i) {
                self.addChild(newShape)
            }
        }
        //Removing shapes
        //we're goin through each childnode in nodetree, looking for the child named "SHAPES", then we get sknode for every child found
        self.enumerateChildNodes(withName: "TARGET") { (node:SKNode, nil) in //shapes need name
            if node.position.y < 255 {
                node.removeFromParent()
            }
        }
        self.enumerateChildNodes(withName: "NOTTARGET") { (node:SKNode, nil) in //shapes need name
            if node.position.y < 255 {
                node.removeFromParent()
            }
        }
    }
    
    func burn (targetPhysicsBody:SKPhysicsBody) {
        let emitter = SKEmitterNode(fileNamed: "SmokeParticle.sks")
        emitter?.position = CGPoint(x: 5, y: 35)
        targetPhysicsBody.node?.addChild(emitter!)
        
        self.run(SKAction.wait(forDuration: 0.2)){
        targetPhysicsBody.node?.removeFromParent()
   //  self.currentScore += 1
        }
  
    }
    
    func congrats (notTargetBody:SKPhysicsBody) {
        let emitter = SKEmitterNode(fileNamed: "SparkParticle.sks")

        emitter?.position = CGPoint(x: 5, y: 35)
        notTargetBody.node?.addChild(emitter!)

        self.run(SKAction.wait(forDuration: 0.2)){
            notTargetBody.node?.removeFromParent()
            
        }
    }
    
    func evilWins(targetBody: SKPhysicsBody)  {
        let scale = SKAction.scale(by: 1.05, duration: 0.5)
        targetBody.node?.run(scale)
        
        self.run(SKAction.wait(forDuration: 0.7)){
            targetBody.node?.removeFromParent()
            
        }
    }
    
    
    func createHUD() {
        pause = self.childNode(withName: "PauseButton") as? SKSpriteNode
        play = self.childNode(withName: "PlayButton") as? SKSpriteNode
        play?.isHidden = true
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        
        //currentScore = 100
        
        
    }
    
    func adjustHealth(by healthAdjustment: Int) {
        // 1
        
 //       if health < 1 {
        health = max(health + healthAdjustment, 0)
        }
//        else {
//        health = max(1,0)
//        if let health = childNode(withName: scoreLabel) as? SKLabelNode {
//            health.text = String(format: "Health: %.1f%%", self.shipHealth * 100)
       

    
}
