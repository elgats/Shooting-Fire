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
        var api: SKSpriteNode?
        var calm: SKSpriteNode?
        var projectile: SKSpriteNode?
        var line: SKSpriteNode?
        var currentTrack = 0
        var startGameScene:SKScene!
    
    //sounds
        let fireSound = SKAction.playSoundFileNamed("flameloop.wav", waitForCompletion: true)
         var backgroundNoise = SKAction.playSoundFileNamed("authormusic-drone-electronics-build-up.mp3", waitForCompletion: true)
        let shotSound = SKAction.playSoundFileNamed("flamethrowerwav.wav", waitForCompletion: false)
        let wrongTargetSound = SKAction.playSoundFileNamed("wrong-buzzer.wav", waitForCompletion: true)
        let evilSound = SKAction.playSoundFileNamed("Evil_Laugh_Male_6-Himan-1359990674.wav", waitForCompletion: true)
       
    
    
        var moveTrack = false
        
        let trackVelocities = [160, 120, 100, 80, 200] //random speed for enemies
        //var directionArray = [Bool]()
        var velocityArray = [Int]()
    
    
    var fireCategory:UInt32 = 0x1 << 0
    let projectileCategory:UInt32 = 0x1 << 1
    var calmCategory:UInt32 = 0x1 << 2
    let targetCategory:UInt32 = 0x1 << 3
    let notTargetCategory:UInt32 = 0x1 << 4
    let lineCategory:UInt32 = 0x1 << 5
    
    //HUD

    var pause:SKSpriteNode?
    var play:SKSpriteNode?
    var timeLabel:SKLabelNode?
    
    var currentTime:TimeInterval = 0 {
        didSet {
            self.timeLabel?.text = "\(Int(self.currentTime))s"
            GameHandler.sharedInstance.timeResult = Int(currentTime)
        }
    }
    
    var scoreLabel:SKLabelNode?
    var health: Int = 100 {
        didSet {
             self.scoreLabel?.text = String("\(health)%")
        }
    }

        override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        self.childNode(withName: "api")?.isHidden = true
        self.childNode(withName: "leftCalm")?.isHidden = true
        self.childNode(withName: "rightCalm")?.isHidden = true
       
        setUpTracks()
        createHUD()
        launchGameTimer()
        createLine()
        createFire()
        calmShape()
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if health <= 20 {
            scoreLabel?.fontColor = UIColor.red
        }
        else {
            scoreLabel?.fontColor = UIColor.white
        }
        
        if health == 0 {
            gameOver()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            if node?.name == "calmButton" {
                
                calm?.position = fire!.position
                calm?.isHidden = false
                fire?.isHidden = true
              childNode(withName: "calmButton")?.isHidden = true
              childNode(withName: "api")?.isHidden = false
              moveCalmButton(show: true)
                
            }
            else if node?.name == "api" {
                
                fire?.position = calm!.position
                fire?.isHidden = false
                calm?.isHidden = true

                childNode(withName: "api")?.isHidden = true
                childNode(withName: "calmButton")?.isHidden = false
                moveCalmButton(show: false)
            }
            else if node?.name == "right" || node?.name == "rightimg" {
                move(node: fire!, pindah: true)
                self.childNode(withName: "calm")?.isHidden = true
            
            }
            else if node?.name == "left" || node?.name == "leftimg" {
                move(node: fire!, pindah: false)
                self.childNode(withName: "calm")?.isHidden = true
            
            }
                
            else if node?.name == "rightCalm" {
                move(node: calm!, pindah: true)
            }
                
            else if node?.name == "leftCalm" {
                move(node: calm!, pindah: false)
            }
                
            else if node?.name == "PauseButton", let scene = self.scene {
                if scene.isPaused {
                    scene.isPaused = false
                    play?.isHidden = true
                    pause?.isHidden = false
                }
                else {
                    scene.isPaused = true
                    play?.isHidden = false
                    pause?.isHidden = true
                    
                }
            }
                
            else if node?.name == "PlayButton", let scene = self.scene {
                if scene.isPaused {
                    scene.isPaused = false
                    pause?.isHidden = false
                    play?.isHidden = true
                }
                else {
                    scene.isPaused = true
                    pause?.isHidden = true
                    play?.isHidden = false
                    
                }
            }
                
            else if node?.name == "retry" {
                let transition = SKTransition.fade(withDuration: 1)
                startGameScene = SKScene(fileNamed: "StartScene")
                startGameScene.scaleMode = .aspectFit
                self.view?.presentScene(startGameScene, transition: transition)
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
                if fire?.isHidden == false {
                addChild(projectile)
                }
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
            calm?.removeAllActions()
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
            
            if fire?.isHidden == false {
 
            if health != 100 {
                adjustHealth(by: 1)
            }
                
            else {
                adjustHealth(by: 0)
            }
            }

            if fire?.isHidden == false {
       burn(targetPhysicsBody: otherBody)
            }
        
        }

        else if fireBody.categoryBitMask == fireCategory && otherBody.categoryBitMask == notTargetCategory {
            
            if fire?.isHidden == false {
          print("collide with non-target")
    
            adjustHealth(by: -1)
            otherBody.node?.removeFromParent()
            self.run(wrongTargetSound)
            }
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
            
            evilWins(targetBody: others)
 
            adjustHealth(by: -1)
        
            
        }
        
        else if line.categoryBitMask == lineCategory && others.categoryBitMask == notTargetCategory {
  
            if health != 100 {
                adjustHealth(by: 1)
            }
                
            else {
                adjustHealth(by: 0)
            }

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
            
            if health != 100 {
                adjustHealth(by: 1)
            }
                
            else {
                adjustHealth(by: 0)
            }

            burn(targetPhysicsBody: shapeBody)
            projectileBody.node?.removeFromParent()
            
            
        }
            
        else if projectileBody.categoryBitMask == projectileCategory && shapeBody.categoryBitMask == notTargetCategory {
            print("collide with non-target")
            
            shapeBody.node?.removeFromParent()
            projectileBody.node?.removeFromParent()
            adjustHealth(by: -1)
            self.run(wrongTargetSound)
            
        }
        
        var calmBody: SKPhysicsBody
        var targetOrNotTargetBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            calmBody = contact.bodyA
            targetOrNotTargetBody = contact.bodyB
        }
        else {
            calmBody = contact.bodyB
            targetOrNotTargetBody = contact.bodyA
        }
        
        if calmBody.categoryBitMask == calmCategory && targetOrNotTargetBody.categoryBitMask == targetCategory {
            
            if calm?.isHidden == false {
            adjustHealth(by: -1)
            evilWins(targetBody: targetOrNotTargetBody)
        }
        }
        
        
        else if calmBody.categoryBitMask == calmCategory && targetOrNotTargetBody.categoryBitMask == notTargetCategory {
            
            if calm?.isHidden == false {
            if health != 100 {
            adjustHealth(by: 1)
            }
            
            else {
                adjustHealth(by: 0)
            }

            congrats(notTargetBody: targetOrNotTargetBody)
            }
            
        }
    }
        
        
    

    func shake() {
        if fire?.isHidden == false {
        print("shake")
        shoot()
        }
    }
    
    
}
