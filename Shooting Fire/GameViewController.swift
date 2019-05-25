//
//  GameViewController.swift
//  Shooting Fire
//
//  Created by Elga Theresia  on 20/05/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.becomeFirstResponder()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "StartScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype,
                              with event: UIEvent?) {
  
        if motion == .motionShake {
            if let skView = view as? SKView, let scene = skView.scene as? GameScene{
                scene.shake()
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
