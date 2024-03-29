
//  GameScene.swift
//  Sushi_watch
//  Created by Gurjeet kaur on 2019-11-01.
//  Copyright © 2019 The Lambton. All rights reserved.

import Foundation
import SpriteKit
import GameplayKit
import WatchConnectivity
class GameScene: SKScene,WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    
    }
    
    let cat = SKSpriteNode(imageNamed: "character1")
    let sushiBase = SKSpriteNode(imageNamed:"roll")
    
    // Make a tower
    var sushiTower:[SushiPiece] = []
    let SUSHI_PIECE_GAP:CGFloat = 80
    var catPosition = "left"
    
    // Show life and score labels
    let lifeLabel = SKLabelNode(text:"Lives: ")
    let scoreLabel = SKLabelNode(text:"Score: ")
    let timeLabel = SKLabelNode(text:"Time: ")
      var pause:Bool = false
      var lives = 5
      var score = 0
      var timeLeft = 25
      var numloops:Int = 0
      var power = ""
    
    
 
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Phone: I received a message from watch: \(message)")
        
        let Side = message["Side"] as! String
    
        print(Side)
        if(timeLeft > 0 && lives > 0 && pause == false){
        towerAnimation()
        catMovement(Side: Side)
        catAnimation()
        scoreGenerator()
            
        }
        
        
        
        let powerUp1 = message["powName"] as! String
        if(powerUp1 == "powerUp")
        {
            timeLeft = timeLeft + 10
        }
        
        else if(powerUp1 == "pause")
        {
           pause = true
           timeLabel.isHidden=true
           lifeLabel.isHidden=true
           scoreLabel.isHidden=true
        }
    
        }
    
    
    
          func catMovement(Side:String)
          {
          if(Side=="left")
          {
           
           print("TAP LEFT")
           // 2. person clicked left, so move cat left
           cat.position = CGPoint(x:self.size.width*0.25, y:100)
                
           // change the cat's direction
           let facingRight = SKAction.scaleX(to: 1, duration: 0)
           self.cat.run(facingRight)
                
            // save cat's position
            self.catPosition = Side
            self.scoreGenerator()
            self.SendUpdateScore()
            
            }
        
            else if(Side=="right")
            {
            print("TAP RIGHT")
            // 2. person clicked right, so move cat right
            cat.position = CGPoint(x:self.size.width*0.85, y:100)
            
            // change the cat's direction
            let facingLeft = SKAction.scaleX(to: -1, duration: 0)
            self.cat.run(facingLeft)
            
            // save cat's position
            self.catPosition = Side
            // self.scoreGenerator()
            //self.SendUpdateScore()
                
            
          }
      }
    
    
    
    func towerAnimation()
    {
        let pieceToRemove = self.sushiTower.first
        if (pieceToRemove != nil) {
            // SUSHI: hide it from the screen & remove from game logic
            pieceToRemove!.removeFromParent()
            self.sushiTower.remove(at: 0)
            
            // SUSHI: loop through the remaining pieces and redraw the Tower
            for piece in sushiTower {
                piece.position.y = piece.position.y - SUSHI_PIECE_GAP
            }
            
            // To make the tower inifnite, then ADD a new piece
            self.spawnSushi()
            
            
            }
     }
    
    
    func catAnimation()
    {
        let image1 = SKTexture(imageNamed: "character1")
        let image2 = SKTexture(imageNamed: "character2")
        let image3 = SKTexture(imageNamed: "character3")
        
        let punchTextures = [image1, image2, image3, image1]
        
        let punchAnimation = SKAction.animate(
            with: punchTextures,
            timePerFrame: 0.1)
        
        self.cat.run(punchAnimation)
        
    }
    
    
    
    
    func scoreGenerator()
    {
        
        if (self.sushiTower.count > 0) {
            // 1. if CAT and STICK are on same side - OKAY, keep going
            // 2. if CAT and STICK are on opposite sides -- YOU LOSE
            let firstSushi:SushiPiece = self.sushiTower[0]
            let chopstickPosition = firstSushi.stickPosition
            
            if (catPosition == chopstickPosition) {
                // cat = left && chopstick == left
                // cat == right && chopstick == right
                print("Cat Position = \(catPosition)")
                print("Stick Position = \(chopstickPosition)")
                print("Conclusion = LOSE")
                print("------")
                
                self.lives = self.lives - 1
                self.lifeLabel.text = "Lives: \(self.lives)"
            }
            else if (catPosition != chopstickPosition) {
                // cat == left && chopstick = right
                // cat == right && chopstick = left
                print("Cat Position = \(catPosition)")
                print("Stick Position = \(chopstickPosition)")
                print("Conclusion = WIN")
                print("------")
                self.score = self.score + 10
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
            
        else {
            print("Sushi tower is empty!")
        }
        
    }
    
        
        
        
        
    
    
    func spawnSushi() {
        
        // 1. Make a sushi
        let sushi = SushiPiece(imageNamed:"roll")
        
        // 2. Position sushi 10px above the previous one
        if (self.sushiTower.count == 0) {
            // Sushi tower is empty, so position the piece above the base piece
            sushi.position.y = sushiBase.position.y
                + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        else {
            // OPTION 1 syntax: let previousSushi = sushiTower.last
            // OPTION 2 syntax:
            let previousSushi = sushiTower[self.sushiTower.count - 1]
            sushi.position.y = previousSushi.position.y + SUSHI_PIECE_GAP
            sushi.position.x = self.size.width*0.5
        }
        
        // 3. Add sushi to screen
        addChild(sushi)
        
        // 4. Add sushi to array
        self.sushiTower.append(sushi)
    }
    
    
    func SendUpdateScore()
    {
    
        print("Sending Message to Watch")
        // code for sending message to WATCH
        if (WCSession.default.isReachable == true) {
            // Here is the message you want to send to the watch
            // All messages get sent as dictionaries
           let Score=String(score)
           let Lives=String(lives)
           let time=String(timeLeft)
           
            
            if(WCSession.default.isReachable == true)
            {
                let message = ["score":Score,"Lives":Lives,"time":time] as [String : Any]
                WCSession.default.sendMessage(message, replyHandler: nil)
                
            }
            else
            {
                print("cannot send message to watch")
                
            }
            
            
        }
    
    
    }
    override func didMove(to view: SKView) {
        
        print(" APP Is Working!")
        // Do any additional setup after loading the view.
        
        if (WCSession.isSupported() == true) {
       print("WC is supported!")
            
        // create a communication session with the watch
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        else {
           print("WC NOT supported!")
        }
        
        // add background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
        
        // add cat
        cat.position = CGPoint(x:self.size.width*0.25, y:100)
        addChild(cat)
        
        // add base sushi pieces
        sushiBase.position = CGPoint(x:self.size.width*0.5, y: 100)
        addChild(sushiBase)
        
        // build the tower
        self.buildTower()
        
        // Game labels
        self.scoreLabel.position.x = 50
        self.scoreLabel.position.y = size.height - 100
        self.scoreLabel.fontName = "Avenir"
        self.scoreLabel.fontSize = 40
        addChild(scoreLabel)
        
        // Life label
        self.lifeLabel.position.x = 50
        self.lifeLabel.position.y = size.height - 150
        self.lifeLabel.fontName = "Avenir"
        self.lifeLabel.fontSize = 40
        addChild(lifeLabel)
        
        
        // time label
        self.timeLabel.position.x = 50
        self.timeLabel.position.y = size.height - 200
        self.timeLabel.fontName = "Avenir"
        self.timeLabel.fontSize = 40
        addChild(timeLabel)
    
    }
    
    func buildTower() {
        for _ in 0...10 {
            self.spawnSushi()
        }
    }
    
   

    override func update(_ currentTime: TimeInterval) {
     numloops = numloops + 1
        if(timeLeft > 0 && timeLeft <= 25)
        {
        if(numloops%60 == 0){
        
        timeLeft -= 1
        self.timeLabel.text =  "Time: \(self.timeLeft)"
            
        }
        }
        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        guard let mousePosition = touches.first?.location(in: self) else {
            return
        }
        
        print(mousePosition)
        
    }
}

