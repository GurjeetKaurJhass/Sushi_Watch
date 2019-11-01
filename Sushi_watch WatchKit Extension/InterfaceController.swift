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
