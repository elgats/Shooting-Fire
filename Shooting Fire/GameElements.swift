//
//  GameElements.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 22/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import SpriteKit
import GameplayKit

enum shapes:Int { //Int so that we can randomize it
    case target
    case notTarget
}

extension GameScene {

    
    func createHUD() {
        pause = self.childNode(withName: "PauseButton") as? SKSpriteNode
        play = self.childNode(withName: "PlayButton") as? SKSpriteNode
        play?.isHidden = true
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        timeLabel = self.childNode(withName: "timeLabel") as? SKLabelNode
    }
    
    func setUpTracks() {
        
        for i in 0 ... 3 {
            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray?.append(track)
            }
        }
        
    }
    
    func createFire() {
     //   fire = SKSpriteNode(imageNamed: "Fire")
        fire = childNode(withName: "Fire") as? SKSpriteNode
        fire?.physicsBody = SKPhysicsBody(circleOfRadius: fire!.size.height)
        fire?.physicsBody?.linearDamping = 0
        fire?.physicsBody?.isDynamic = true
        fire?.physicsBody?.categoryBitMask = fireCategory
        fire?.physicsBody?.collisionBitMask = 0
        fire?.physicsBody?.usesPreciseCollisionDetection = true
        
        //   fire?.physicsBody?.contactTestBitMask = shapeCategory
        
    //    fire?.position = calm!.position
       fire?.position = CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        
        animateFire()
       // self.addChild(fire!)
    }
    
    func animateFire() {
        let flame = SKEmitterNode(fileNamed: "FireParticle")!
        
        fire?.addChild(flame)
        flame.position = CGPoint(x: 0, y: -50)
    }
    
//    func apiImage() {
//     let api = childNode(withName: "api")
//        //self.addChild(api!)
//   // api?.isHidden = true
//    }
    
    func calmShape() {
     //   calm = SKSpriteNode(imageNamed: "calm")
        calm = childNode(withName: "calm") as? SKSpriteNode
        calm?.physicsBody?.linearDamping = 0
        calm?.physicsBody?.isDynamic = true
        calm?.position = fire!.position
       // calm?.position = CGPoint(x: size.width * 0.5, y: size.height * 0.25)
        calm?.physicsBody = SKPhysicsBody(circleOfRadius: calm!.size.height)
        calm?.physicsBody?.categoryBitMask = calmCategory
        calm?.physicsBody?.collisionBitMask = 0
        calm?.physicsBody?.usesPreciseCollisionDetection = true
        
       // self.addChild(calm!)
        
    }
    

    
    func sound() {
        let loopSound:SKAction = SKAction.repeatForever(fireSound)
        self.run(loopSound)
        let backgroundMusic:SKAction = SKAction.repeatForever(backgroundNoise)
        self.run(backgroundMusic)
    }
    
    func createLine() {
        let line = self.childNode(withName: "line") as? SKSpriteNode
        line?.physicsBody = SKPhysicsBody(rectangleOf: line!.size)
        line?.physicsBody?.categoryBitMask = lineCategory
        line?.physicsBody?.collisionBitMask = 0
    }
    
    func createShapes (type: shapes, forTrack track: Int) -> SKShapeNode? {
        let shapeSprite = SKShapeNode()
       // shapeSprite.name  = "SHAPES"
        switch type {
        case .target:
            shapeSprite.name  = "TARGET"
            shapeSprite.path = CGPath(roundedRect: CGRect(x: -40, y: 0, width: 90, height: 90), cornerWidth: 220, cornerHeight: 220, transform: nil)
            shapeSprite.fillColor = UIColor(red: 238/255, green: 22/255, blue: 22/255, alpha: 1)
            shapeSprite.fillTexture = SKTexture.init(image: UIImage(named: "Devil")!)
            shapeSprite.glowWidth = 2
            shapeSprite.strokeColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            shapeSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: shapeSprite.path!)
          //  shapeSprite.physicsBody?.isDynamic = true
            shapeSprite.physicsBody?.categoryBitMask = targetCategory
            
            shapeSprite.physicsBody?.collisionBitMask = fireCategory | projectileCategory
            shapeSprite.physicsBody?.contactTestBitMask = fireCategory | lineCategory | projectileCategory | calmCategory

            
        case .notTarget:
           shapeSprite.name  = "NOTTARGET"
            shapeSprite.path = CGPath(roundedRect: CGRect(x: -40, y: 0, width: 90, height: 90), cornerWidth: 220, cornerHeight: 220, transform: nil)
            shapeSprite.fillColor = UIColor(red: 31/255, green: 204/255, blue: 0/255, alpha: 1)
           shapeSprite.fillTexture = SKTexture.init(image: UIImage(named: "Good")!)
            shapeSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: shapeSprite.path!)
          //  shapeSprite.physicsBody?.isDynamic = true
            shapeSprite.physicsBody?.categoryBitMask = notTargetCategory
           
           shapeSprite.physicsBody?.collisionBitMask = 0
           shapeSprite.physicsBody?.contactTestBitMask = fireCategory | lineCategory | projectileCategory | calmCategory

        }
        
        guard let shapePosition = tracksArray?[track].position else {return nil}
        //
        //        let pindah = directionArray[track]
        //
        shapeSprite.position.x = shapePosition.x
        shapeSprite.position.y = self.size.height + 130
        
        
        shapeSprite.physicsBody?.velocity = CGVector(dx: 0, dy: -velocityArray[track])
        return shapeSprite
    }
}
