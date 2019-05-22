//
//  GameScene.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 20/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion



func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
        var tracksArray: [SKSpriteNode]? = [SKSpriteNode]() //() for initilizing tracks
        var fire: SKSpriteNode?
        var projectile: SKSpriteNode?
        var line: SKSpriteNode?
        var currentTrack = 0
        let fireSound = SKAction.playSoundFileNamed("flameloop.wav", waitForCompletion: true)
    
        let shotSound = SKAction.playSoundFileNamed("flamethrowerwav.wav", waitForCompletion: false)
        var moveTrack = false
    
        let trackVelocities = [120, 150,200] //random speed for enemies
        //var directionArray = [Bool]()
        var velocityArray = [Int]()
    
    let fireCategory:UInt32 = 0x1 << 0
    let targetCategory:UInt32 = 0x1 << 1
    let notTargetCategory:UInt32 = 0x1 << 2
    let lineCategory:UInt32 = 0x1 << 3

        override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        setUpTracks()
        createLine()
        createFire()
        sound()

        
        if let numberOfTracks = tracksArray?.count {
            for _ in 0 ... numberOfTracks {
                let randomNumberForVelocity = GKRandomSource.sharedRandom().nextInt(upperBound: 3) //3 because we only have 3 options for speed
                velocityArray.append(trackVelocities[randomNumberForVelocity])

            }
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spawnShapes()
        }, SKAction.wait(forDuration: 5)])))
        } // call shape, wait a bit, call shape again
    

    
    func projectileDidCollideWithShape(projectile: SKSpriteNode, shapeSprite: SKShapeNode) {
        print("Hit")
        projectile.removeFromParent()
        shapeSprite.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            if node?.name == "api" {
                shoot()
            }
            else if node?.name == "right" {
                move(pindah: true)
            }
            else if node?.name == "left" {
                move(pindah: false)
            }
            else {
            
            let projectile = SKSpriteNode(imageNamed: "Particle")
            projectile.position = fire!.position
            let flame = SKEmitterNode(fileNamed: "FireParticle")!
            projectile.addChild(flame)
            flame.position = CGPoint(x: 0, y: -50)
            // 3 - Determine offset of location to projectile
            let offset = location - fire!.position
            
            // 4 - Bail out if you are shooting down or backwards
            if offset.y < 0 { return }
            //
            // 5 - OK to add now - you've double checked position
            addChild(projectile)
            
            // 6 - Get the direction of where to shoot
            let direction = offset.normalized()
            
            // 7 - Make it shoot far enough to be guaranteed off screen
            let shootAmount = direction * 1000
            
            // 8 - Add the shoot amount to the current position
            let realDest = shootAmount + projectile.position
            
            // 9 - Create the actions
            let actionMove = SKAction.move(to: realDest, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: fire!.size.width / 2)
            projectile.physicsBody?.linearDamping = 0
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = fireCategory
            projectile.physicsBody?.collisionBitMask = targetCategory | notTargetCategory
         //   projectile.physicsBody?.contactTestBitMask = shapeCategory
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            self.run(shotSound)
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        var fireBody: SKPhysicsBody
        var otherBody: SKPhysicsBody
//        //to make sure that the firebody is always the firebody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            fireBody = contact.bodyA
            otherBody = contact.bodyB
        }
        else {
            fireBody = contact.bodyB
            otherBody = contact.bodyA
        }

        if fireBody.categoryBitMask == fireCategory && otherBody.categoryBitMask == targetCategory {
            print("collide with target")
        }

        else if fireBody.categoryBitMask == fireCategory && otherBody.categoryBitMask == notTargetCategory {
            print("collide with non-target")
        }
        
        
    }

    func shake() {
        print("shake")
        shoot()
    }
}
