//
//  InterfaceController.swift
//  Sushi_watch WatchKit Extension
//
//  Created by Gurjeet kaur on 2019-11-01.
//  Copyright © 2019 The Lambton. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    @IBAction func moveCatLeft() {
        
        print("Sending Message to Phone")
        
        if (WCSession.default.isReachable == true)
        {
            let message = ["Side":"left","powName":""]
            // as [String : Any]
            // send the message
             WCSession.default.sendMessage(message, replyHandler: nil)
             print("message sent")
            print("user clicked left")
        }
        
        else {
        
           print("Message Cannot be sent")
           
             }
    
    }
    
    
    
    @IBAction func moveCatRight() {
        print("Sending Message to Phone")
        
        if (WCSession.default.isReachable == true)
        {
            let message = ["Side":"right","powName":""]
            // as [String : Any]
            // send the message
            WCSession.default.sendMessage(message, replyHandler: nil)
            print("message sent")
            print("user clicked right")
        }
            
        else {
            
            print("Message Cannot be sent")
        }
        
        
        
    }
    
    @IBOutlet weak var scoreLives: WKInterfaceLabel!
    
    
 
    
    @IBOutlet weak var power1: WKInterfaceButton!
    
       @IBAction func pause() {
        
        if(WCSession.default.isReachable == true){
            let message = ["Side":"","powName":"pause"] as [String : Any]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        
        
        
       }
    @IBAction func power() {
        power1.setHidden(true)
        powerUp.setHidden(true)
          let powerUp=""
        if(WCSession.default.isReachable == true){
            let message = ["Side":"","powName":"powerUp"] as [String : Any]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        
        
        
    }
    
        
        
        
        
    
    @IBOutlet weak var powerUp: WKInterfaceImage!
    @IBOutlet weak var powerLeft: WKInterfaceImage!
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        print("Received a message from phone: \(message)")
        

        let score = message["score"] as! String
        let lives = message["Lives"] as! String
        var time = message["time"] as! String
        scoreLives.setText("S: \(score), L: \(lives) T: \(time)")
        
        if(time == "15" || time == "10"  || time == "5" )
        {
         powerUp.setImageNamed("idea")
         power1.setHidden(false)
         powerUp.setHidden(false)
            
//        scoreLives.setText("S: \(score), L: \(lives) T: \(time)")
//
        }
        
        if(time == "15"){
                
         powerLeft.setImageNamed("battery (2)")
         msgfromPhoneLabel.setText("15s left")
         msgfromPhoneLabel.setHidden(false)
         DispatchQueue.main.asyncAfter(deadline: .now() + 2){
         self.msgfromPhoneLabel.setHidden(true)
               }
              }

         else if(time == "10"){
         powerLeft.setImageNamed("battery (2)")
         msgfromPhoneLabel.setText("10s left")
         msgfromPhoneLabel.setHidden(false)
         DispatchQueue.main.asyncAfter(deadline: .now() + 2){
         self.msgfromPhoneLabel.setHidden(true)
            
            }
         }
            
            
          else if(time == "5"){
          powerLeft.setImageNamed("battery (1)")
          msgfromPhoneLabel.setText("5s left")
          msgfromPhoneLabel.setHidden(false)
          DispatchQueue.main.asyncAfter(deadline: .now() + 2){
          self.msgfromPhoneLabel.setHidden(true)
            
              }
          }
            
            
            
          else if(time == "0" || lives <= "0"){
                 
          powerLeft.setImageNamed("game-over")
          msgfromPhoneLabel.setHidden(false)
          msgfromPhoneLabel.setText("Your score:\(score)")
                  
               }
        
         }
   
    
    
    @IBOutlet weak var msgfromPhoneLabel: WKInterfaceLabel!
    
     override func willActivate() {
        
        // This method is called when watch view controller is about to be visible to user
        
        super.willActivate()
        print("Watch Loaded")
        
        if (WCSession.isSupported() == true)
        {
            msgfromPhoneLabel.setText("connected")
            
            // create a communication session with the phone
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        else
        {
            msgfromPhoneLabel.setText("not connected")
        }
        
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
