//
//  GameScene.swift
//  Lab9
//
//  Created by IMD 224 on 2024-03-20.
//

import SpriteKit
import UIKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sprite : SKSpriteNode!
    var opponentSprite : SKSpriteNode!
    let spriteCategory1 : UInt32 = 0b1
    let spriteCategory2 : UInt32 = 0b10
    var counter = 0
    var hitCounter : SKLabelNode!
    var xLocation = 500
    
    override func didMove(to view: SKView) {
        
        
        displayScore()
        sprite = SKSpriteNode(imageNamed: "PlayerSprite")
        sprite.position = CGPoint(x: size.width / 2, y: 100)
        sprite.size = CGSize(width: 75, height: 75)
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        sprite.physicsBody?.categoryBitMask = spriteCategory1
        sprite.physicsBody?.contactTestBitMask = spriteCategory1
        sprite.physicsBody?.collisionBitMask = spriteCategory1
        addChild(sprite)
        
        
        
        opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
        xLocation = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width))
        opponentSprite.position = CGPoint(x: CGFloat(Float(xLocation)), y: size.height)
        opponentSprite.size = CGSize(width: 75, height: 75)
       
        opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
       
        opponentSprite.physicsBody?.categoryBitMask = spriteCategory1
        opponentSprite.physicsBody?.contactTestBitMask = spriteCategory1
        opponentSprite.physicsBody?.collisionBitMask = spriteCategory1
        self.physicsWorld.contactDelegate = self
        
        addChild(opponentSprite)
        let downMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: 0), duration: 1)
        let upMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height), duration: 1)
        let movement = SKAction.sequence([downMovement, upMovement])
        moveOpponent()
        
       
    }
    
    func displayScore() {
        hitCounter = SKLabelNode(fontNamed: "Chalkduster")
        hitCounter.text = String(counter)
        hitCounter.fontSize = 65
        hitCounter.fontColor = SKColor.green
        hitCounter.position = CGPoint(x: frame.midX, y: frame.midY)
           
        addChild(hitCounter)
        
    }
    
    func moveOpponent() {
        
        //let randomY = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.height))
        let randomInt = Int.random(in: 2..<6)
        //let topOfScreen =
        let movement = SKAction.move(to: CGPoint(x: xLocation, y: 0), duration: TimeInterval(randomInt))
        xLocation = GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width))
        opponentSprite.run(movement, completion: { [unowned self] in
          print("bottom ")
            let move = SKAction.move(to: CGPoint(x: CGFloat(Float(xLocation)), y: size.height), duration: TimeInterval(0))
            counter -= 1
            hitCounter.text = String(counter)
            opponentSprite.run(move)
           
            gameOver()
        self.moveOpponent()
        })
        

    }
    
    func gameOver() {
        if(counter < 0){
            exit(0)
        }
    }
    

    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("Hit!")
        counter += 1
        hitCounter.text = String(counter)
        opponentSprite.removeAllActions()
        let move = SKAction.move(to: CGPoint(x: CGFloat(Float(xLocation)), y: size.height), duration: TimeInterval(0))
        opponentSprite.run(move)
        
        self.moveOpponent()
       
    }
    
    func touchDown(atPoint pos : CGPoint) {
        sprite.run(SKAction.moveTo(x: CGFloat(Float(pos.x)), duration: 1))

    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
        sprite.run(SKAction.moveTo(x: CGFloat(Float(pos.x)), duration: 1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
