//
//  SessionModel.swift
//  DJTogether
//
//  Created by cse-loaner on 3/17/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class Session {
  var peerID: MCPeerID!
  var mcSession: MCSession!
  var mcAdvertiserAssistant: MCAdvertiserAssistant!
  let DJTogetherServiceType = "dj-together"
  var isHost = false
  
  init(_ delegate: MCSessionDelegate) {
    peerID = MCPeerID(displayName: UIDevice.current.name)
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession.delegate = delegate
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: DJTogetherServiceType, discoveryInfo: nil, session: mcSession)
  }
  
  var delegate : MCSessionDelegate! {
    get { return mcSession.delegate! }
    set { mcSession.delegate = newValue }
  }
  
  var hosting: Bool {
    get { return isHost }
    set { isHost = newValue }
  }
  
}
