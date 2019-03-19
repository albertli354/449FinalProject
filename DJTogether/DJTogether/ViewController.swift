//
//  ViewController.swift
//  DJTogether
//
//  Created by Xiang Li on 3/5/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
  var session: Session!

  @IBOutlet weak var createPartyButton: UIButton!
  @IBOutlet weak var joinPartyButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    if session == nil {
      session = Session(self)
    }
  }
  
  func startHosting(action: UIAlertAction!) {
    session.mcAdvertiserAssistant.start()
    session.hosting = true
    let requestedScopes: SPTScope = [.appRemoteControl]
    AppDelegate.sharedInstance.sessionManager.initiateSession(with: requestedScopes, options: .default)
    performSegue(withIdentifier: "mainToHost", sender: self)
    
  }
  
  func joinSession(action: UIAlertAction!) {
    let mcBrowser = MCBrowserViewController(serviceType: session.DJTogetherServiceType, session: session.mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
    session.hosting = false
  }
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    // do things
    switch state {
    case MCSessionState.connected:
      NSLog("Connected: \(peerID.displayName)")
    case MCSessionState.connecting:
      NSLog("Connecting: \(peerID.displayName)")
    
    case MCSessionState.notConnected:
      NSLog("Not Connected: \(peerID.displayName)")
    }
  }
  
  @IBAction func button_pressed(_ sender: UIButton) {
    switch sender {
    case createPartyButton:
      startHosting(action: UIAlertAction())
    case joinPartyButton:
      joinSession(action: UIAlertAction())
    default:
      NSLog("Unknown button pressed")
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    // if let <var> = <data type>(data)
    // work with data received
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    // nothing required
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    // nothing required
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    // nothing required
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
    performSegue(withIdentifier: "mainToGuest", sender: self)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier! {
    case "mainToHost":
      let destination = segue.destination as! HostViewController
      destination.session = session
      NSLog("Segue to Host page")
    case "mainToGuest":
      let destination = segue.destination as! GuestViewController
      destination.session = session
      NSLog("Segue to Guest page")
    default:
      NSLog("Unknown segue identifier: \(segue.identifier!)")
    }
  }
}

