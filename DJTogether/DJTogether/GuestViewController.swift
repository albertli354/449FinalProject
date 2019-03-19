//
//  GuestViewController.swift
//  DJTogether
//
//  Created by cse-loaner on 3/15/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class GuestViewController: UIViewController, MCSessionDelegate {
  
  var songs : [Song] = []
  var session: Session!
  var song = Song("", "")
  @IBOutlet weak var messageField: UILabel!
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    if session == nil {
      NSLog("Session is nil when it shouldn't be")
    }
    session.delegate = self
      // Do any additional setup after loading the view.
  }
    
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    let song: Song? = try? JSONDecoder().decode(Song.self, from: data)
    if let song = song {
      self.song = song
      DispatchQueue.main.async { [unowned self] in
        self.messageField.text = self.song.title
      }
    } else {
      let songs: [Song]? = try? JSONDecoder().decode([Song].self, from: data)
      if let songs = songs {
        self.songs = songs
        performSegue(withIdentifier: "guestToPoll", sender: self)
      }
    }
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier! {
    case "guestToPoll":
      let destination = segue.destination as! PollViewController
      destination.session = self.session
      destination.songs = self.songs
      NSLog("Segue to Guest Poll Page")
    default:
      NSLog("Unknown segue identifier: \(segue.identifier!)")
    }
  }

}
