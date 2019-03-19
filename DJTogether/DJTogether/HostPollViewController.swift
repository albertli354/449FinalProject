//
//  HostViewController.swift
//  DJTogether
//
//  Created by cse-loaner on 3/15/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HostPollViewController: UIViewController, MCSessionDelegate, UITableViewDataSource, UITableViewDelegate {
  

  var songs = [Song("Mr. Blue Sky", "spotify:track:2RlgNHKcydI9sayD2Df2xp"),
               Song("Come a Little Bit Closer", "spotify:track:252YuUdUaC5OojaBU0H1CP"),
               Song("Bohemian Rhapsody", "spotify:track:7tFiyTwD0nx5a1eklYtX2J")]
  var session: Session!
  var results = false

  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
    if session == nil {
      NSLog("Session is nil when it shouldn't be")
    }
    session.delegate = self
    tableView.allowsSelection = true
    tableView.allowsMultipleSelection = true
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  func sendPoll() {
    if session.mcSession.connectedPeers.count > 0 {
      // send list of songs
      do {
        let selectedSongs = songs.filter { return $0.isSelected }
        let jsonData =  try JSONEncoder().encode(selectedSongs)
//        let jsonData = try NSKeyedArchiver.archivedData(withRootObject: jsonArr, requiringSecureCoding: true)
        do {
          // send the song list
          try session.mcSession.send(jsonData, toPeers: session.mcSession.connectedPeers, with: .reliable)
          // show only available songs and votes
          songs = selectedSongs
          tableView.allowsMultipleSelection = false
          tableView.allowsSelection = false
          results = true
          tableView.reloadData()
        } catch let error as NSError {
          let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      } catch {}
    }
  }
  
  func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
    
  }
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    if let message = String(data: data, encoding: .utf8) {
      let votePrefix = "Vote: "
      if message.hasPrefix(votePrefix) {
        var title = message.substring(from: votePrefix.endIndex)
        var song = songs.filter { return $0.title == title }.first!
        song.votes = song.votes + 1
        DispatchQueue.main.async { [unowned self] in
          self.tableView.reloadData()
        }
      }
    }
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
  }
  
  
  @IBAction func buttonPressed(_ sender: UIButton) {
    switch sender {
    case sendButton:
      sendPoll()
    default:
      NSLog("Unknown button pressed")
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return songs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
    cell.song = songs[indexPath.row]
    cell.voteLabel.isHidden = !results
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    NSLog("You selected cell #\(indexPath.row)!")
    songs[indexPath.row].isSelected = true
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    NSLog("You deselected cell #\(indexPath.row)!")
    songs[indexPath.row].isSelected = false
  }

}
