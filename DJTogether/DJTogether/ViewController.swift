//
//  ViewController.swift
//  DJTogether
//
//  Created by Xiang Li on 3/5/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://djtogether.herokuapp.com/api/token"),
            let tokenRefreshURL = URL(string: "https://djtogether.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = "spotify:track:2RlgNHKcydI9sayD2Df2xp"
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    var appRemote: SPTAppRemote {
        get {
            return AppDelegate.sharedInstance.appRemote
        }
    }
    
    /*
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    */
    
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        self.appRemote.connectionParameters.accessToken = session.accessToken
        self.appRemote.connect()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print(session)
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        print("connected")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("state changed")
    }
    
    
    
    
    
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
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        if #available(iOS 11, *) {
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        } else {
            sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
        }
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

