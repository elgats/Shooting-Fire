//
//  GameScene.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 20/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit
import GameplayKit



enum shapes:Int { //Int so that we can randomize it
    case target
    case notTarget
}

class GameScene: SKScene {
    
        var tracksArray: [SKSpriteNode]? = [SKSpriteNode]() //() for initilizing tracks
        var fire: SKSpriteNode?
        var currentTrack = 0
        let fireSound = SKAction.playSoundFileNamed("flameloop.wav", waitForCompletion: true)
    
        //let soundtrack = SKAction.playSoundFileNamed("POL-sage-rage-short.wav", waitForCompletion: true)
        let shotSound = SKAction.playSoundFileNamed("flamethrowerwav.wav", waitForCompletion: false)
        var moveTrack = false
    
        let trackVelocities = [120, 150,200] //random speed for enemies
        var directionArray = [Bool]()
        var velocityArray = [Int]()
    
    let fireCategory:UInt32 = 0x1 << 0
    let shapeCategory:UInt32 = 0x1 << 1
    let lineCategory:UInt32 = 0x1 << 2
    
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
        
        setUpTracks()
        createFire()
        sound()
//        self.addChild(createShapes(type: .target, forTrack: 0)!)
        
        //check the tracks first
        
        if let numberOfTracks = tracksArray?.count {
            for _ in 0 ... numberOfTracks {
                let randomNumberForVelocity = GKRandomSource.sharedRandom().nextInt(upperBound: 3) //3 because we only have 3 options for speed
                velocityArray.append(trackVelocities[randomNumberForVelocity])
                    directionArray.append(GKRandomSource.sharedRandom().nextBool())
            }
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spawnShapes()
        }, SKAction.wait(forDuration: 5)])))
        } // call shape, wait a bit, call shape again

    func setUpTracks() {
        
        for i in 0 ... 4 {
            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray?.append(track)
            }
        }
        
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
            
            if ((fire?.position.x)!) <= 525 {
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
            
            if ((fire?.position.x)!) >= 50 {
                fire?.run(repeatAction, withKey: "moveLeft")
            }

            else {
                fire?.removeAction(forKey: "moveLeft")
            }
        }
    }
        
    func shoot() {
        fire?.removeAllActions()
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
        
        fire?.position = CGPoint(x: size.width * 0.5, y: size.height * 0.3)
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
        shapeSprite.name  = "SHAPES"
        switch type {
        case .target:
            shapeSprite.path = CGPath(roundedRect: CGRect(x: -40, y: 0, width: 90, height: 90), cornerWidth: 220, cornerHeight: 220, transform: nil)
            shapeSprite.fillColor = UIColor(red: 238/255, green: 22/255, blue: 22/255, alpha: 1)
            
            
//            shapeSprite.alpha = 1
            
        case .notTarget:
            shapeSprite.path = CGPath(roundedRect: CGRect(x: -40, y: 0, width: 90, height: 90), cornerWidth: 220, cornerHeight: 220, transform: nil)
            shapeSprite.fillColor = UIColor(red: 31/255, green: 204/255, blue: 0/255, alpha: 1)
        }
        
        guard let shapePosition = tracksArray?[track].position else {return nil}
        
        let pindah = directionArray[track]
        
        shapeSprite.position.x = shapePosition.x
        shapeSprite.position.y = pindah ? 1300 : self.size.height + 130
        
        shapeSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: shapeSprite.path!)
        
        shapeSprite.physicsBody?.velocity = pindah ? CGVector(dx: 0, dy: -velocityArray[track]) : CGVector(dx: 0, dy: -velocityArray[track])
        
        return shapeSprite
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
        self.enumerateChildNodes(withName: "SHAPES") { (node:SKNode, nil) in //shapes need name
            if node.position.y < -150 || node.position.y > self.size.height + 150 {
            node.removeFromParent()
        }
    }
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype,
                     with event: UIEvent?) {
//        if let fire = self.fire {
//            let shooting = SKAction.moveBy(x: 0, y: 3000, duration: 2)
//        fire.run(shooting)
//
//        createFire()
        shoot()
        }
   // }
}
