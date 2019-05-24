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
        let wrongTargetSound = SKAction.playSoundFileNamed("wrong-buzzer.wav", waitForCompletion: true)
        var moveTrack = false
        
        let trackVelocities = [160, 120, 100, 80, 200] //random speed for enemies
        //var directionArray = [Bool]()
        var velocityArray = [Int]()
    
    let fireCategory:UInt32 = 0x1 << 0
    let projectileCategory:UInt32 = 0x1 << 1
    let targetCategory:UInt32 = 0x1 << 2
    let notTargetCategory:UInt32 = 0x1 << 3
    let lineCategory:UInt32 = 0x1 << 4
    
    //HUD
    
    var instruction:SKLabelNode?
  //  var timeLabel:SKLabelNode?
    var scoreLabel:SKLabelNode?
    
//    var remainingTime:TimeInterval = 5 {
//        didSet {
//            self.timeLabel?.text = "Stop for: \(self.remainingTime)"
//        }
//    }
//    
    var currentScore:Int = 0 {
        didSet {
            self.scoreLabel?.text = "Score: \(self.currentScore)"
        }
    }

        override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        setUpTracks()
        createHUD()
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
        }, SKAction.wait(forDuration: 3)])))
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
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: fire!.size.width)
            projectile.physicsBody?.linearDamping = 0
            projectile.physicsBody?.isDynamic = true
            projectile.physicsBody?.categoryBitMask = projectileCategory
            projectile.physicsBody?.collisionBitMask = 0
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

        currentScore += 1
//                
       burn(targetPhysicsBody: otherBody)
           
        
        }

        else if fireBody.categoryBitMask == fireCategory && otherBody.categoryBitMask == notTargetCategory {
          print("collide with non-target")
            currentScore -= 1
            otherBody.node?.removeFromParent()
            self.run(wrongTargetSound)
          
            }
        
        var line: SKPhysicsBody
        var others: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            line = contact.bodyA
            others = contact.bodyB
        }
        else {
            line = contact.bodyB
            others = contact.bodyA
        }
        
        if line.categoryBitMask == lineCategory && others.categoryBitMask == targetCategory {
            others.node?.removeFromParent()
            currentScore -= 1
        }
        
        else if line.categoryBitMask == lineCategory && others.categoryBitMask == notTargetCategory {
         self.currentScore += 1
        congrats(notTargetBody: others)
            
        }
        
        var projectileBody: SKPhysicsBody
        var shapeBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            projectileBody = contact.bodyA
            shapeBody = contact.bodyB
        }
        else {
            projectileBody = contact.bodyB
            shapeBody = contact.bodyA
        }
        
        if projectileBody.categoryBitMask == projectileCategory && shapeBody.categoryBitMask == targetCategory {
            
           currentScore += 1

            burn(targetPhysicsBody: otherBody)
            projectileBody.node?.removeFromParent()
            
            
        }
            
        else if projectileBody.categoryBitMask == projectileCategory && shapeBody.categoryBitMask == notTargetCategory {
            print("collide with non-target")
            
            currentScore -= 1
           // self.run(currentScore -= 1), waitForCompletion: true
            shapeBody.node?.removeFromParent()
            projectileBody.node?.removeFromParent()
            
            self.run(wrongTargetSound)
            
        }
    }
        
        
    

    func shake() {
        print("shake")
        shoot()
    }
    
    
}
