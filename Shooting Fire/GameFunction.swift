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
    
    

    func move (pindah: Bool) {
        if pindah {
            let moving = SKAction.moveBy(x: 15, y: 0, duration: 0.1)
            let repeatAction = SKAction.repeatForever(moving)
            
            if ((fire?.position.x)!) <= 500 {
                fire?.run(repeatAction, withKey: "moveRight")
            }
                
            else {
                fire?.removeAction(forKey: "moveRight")
            }

        }
            
        else {
            let moving = SKAction.moveBy(x: -15, y: 0, duration: 0.1)
            let repeatAction = SKAction.repeatForever(moving)
           // fire?.run(repeatAction)
            
            if ((fire?.position.x)!) >= 220 {
                fire?.run(repeatAction, withKey: "moveLeft")
            }
                
            else {
                fire?.removeAction(forKey: "moveLeft")
            }
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

        self.run(SKAction.wait(forDuration: 0.1)){
            notTargetBody.node?.removeFromParent()
            
        }
    }
    
    func createHearts() {
        let heart1:SKSpriteNode = self.childNode(withName: "heart1") as! SKSpriteNode
        let heart2:SKSpriteNode = self.childNode(withName: "heart2") as! SKSpriteNode
        let heart3:SKSpriteNode = self.childNode(withName: "heart3") as! SKSpriteNode
         var lives: [SKSpriteNode] = [heart1, heart2, heart3]
        
    }
    
    func createHUD() {
        pause = self.childNode(withName: "PauseButton") as? SKSpriteNode
        play = self.childNode(withName: "PlayButton") as? SKSpriteNode
        play?.isHidden = true
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        
        currentScore = 0
        
        
    }
    
    func livesReduced() {
        
       
        lives?.first?.removeFromParent()
        

}
}
