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
            
            if ((fire?.position.x)!) >= 160 {
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
        projectile.physicsBody?.categoryBitMask = fireCategory
        projectile.physicsBody?.collisionBitMask = 0
        projectile.physicsBody?.contactTestBitMask = targetCategory | notTargetCategory
        projectile.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func spawnShapes() {
        
        for i in 0 ... 4 { //4 = number of tracks
            let randomShapeType = shapes(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 2))!
            if let newShape = createShapes(type: randomShapeType, forTrack: i) {
                self.addChild(newShape)
            }
        }
        //Removing shapes
        //we're goin through each childnode in nodetree, looking for the child named "SHAPES", then we get sknode for every child found
        self.enumerateChildNodes(withName: "TARGET") { (node:SKNode, nil) in //shapes need name
            if node.position.y < 250 {
                node.removeFromParent()
            }
        }
        self.enumerateChildNodes(withName: "NOTTARGET") { (node:SKNode, nil) in //shapes need name
            if node.position.y < 250 {
                node.removeFromParent()
            }
        }
    }
    
}
