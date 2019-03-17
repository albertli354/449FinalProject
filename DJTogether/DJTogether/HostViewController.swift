//
//  HostViewController.swift
//  DJTogether
//
//  Created by cse-loaner on 3/15/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HostViewController: UIViewController, MCSessionDelegate {
  
  var session: Session!
  
  @IBOutlet weak var messageField: UITextField!
  @IBOutlet weak var sendButton: UIButton!
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
    if session == nil {
      NSLog("Session is nil when it shouldn't be")
    }
    session.delegate = self
  }
  
  func sendMessage() {
    if session.mcSession.connectedPeers.count > 0 {
      if let message = messageField.text!.data(using: .utf8) {
        do {
          try session.mcSession.send(message, toPeers: session.mcSession.connectedPeers, with: .reliable)
        } catch let error as NSError {
          let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      }
    }
  }
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
  }
  
  
  @IBAction func buttonPressed(_ sender: UIButton) {
    switch sender {
    case sender:
      sendMessage()
    default:
      NSLog("Unknown button pressed")
    }
  }
}
