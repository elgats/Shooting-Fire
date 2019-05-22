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

    func setUpTracks() {
        
        for i in 0 ... 4 {
            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray?.append(track)
            }
        }
        
    }
    
    func createFire() {
        fire = SKSpriteNode(imageNamed: "Fire")
        fire?.physicsBody = SKPhysicsBody(circleOfRadius: fire!.size.height / 2)
        fire?.physicsBody?.linearDamping = 0
        fire?.physicsBody?.isDynamic = true
        fire?.physicsBody?.categoryBitMask = fireCategory
        fire?.physicsBody?.collisionBitMask = 0
        //   fire?.physicsBody?.contactTestBitMask = shapeCategory
        
        
        fire?.position = CGPoint(x: size.width * 0.5, y: size.height * 0.3)
        
        animateFire()
        self.addChild(fire!)
    }
    
    func animateFire() {
        let flame = SKEmitterNode(fileNamed: "FireParticle")!
        
        fire!.addChild(flame)
        flame.position = CGPoint(x: 0, y: -50)
    }
    
    func sound() {
        let loopSound:SKAction = SKAction.repeatForever(fireSound)
        self.run(loopSound)
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
            shapeSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: shapeSprite.path!)
            shapeSprite.physicsBody?.isDynamic = true
            shapeSprite.physicsBody?.categoryBitMask = targetCategory
            
            
        case .notTarget:
           shapeSprite.name  = "NOTTARGET"
            shapeSprite.path = CGPath(roundedRect: CGRect(x: -40, y: 0, width: 90, height: 90), cornerWidth: 220, cornerHeight: 220, transform: nil)
            shapeSprite.fillColor = UIColor(red: 31/255, green: 204/255, blue: 0/255, alpha: 1)
            shapeSprite.physicsBody = SKPhysicsBody(edgeLoopFrom: shapeSprite.path!)
            shapeSprite.physicsBody?.isDynamic = true
            shapeSprite.physicsBody?.categoryBitMask = notTargetCategory
        }
        
        guard let shapePosition = tracksArray?[track].position else {return nil}
        //
        //        let pindah = directionArray[track]
        //
        shapeSprite.position.x = shapePosition.x
        shapeSprite.position.y = self.size.height + 130
        
        
        
        shapeSprite.physicsBody?.collisionBitMask = fireCategory | lineCategory
        shapeSprite.physicsBody?.contactTestBitMask = fireCategory | lineCategory
        shapeSprite.physicsBody?.velocity = CGVector(dx: 0, dy: -velocityArray[track])
        return shapeSprite
    }
}
