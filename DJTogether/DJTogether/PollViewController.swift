///Users/cse-loaner/Documents/IOS_Dev/449FinalProject/DJTogether/DJTogether/HostPollViewController.swift
//  PollViewController.swift
//  DJTogether
//
//  Created by cse-loaner on 3/18/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import UIKit

class PollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var submitButton: UIButton!
  
  var songs : [Song] = []
  var currentSong : Song!
  var session: Session!
  var selectedRow = -1
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      tableView.delegate = self
      tableView.dataSource = self
      submitButton.layer.cornerRadius = 10
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return songs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
    cell.songData = songs[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    NSLog("You selected cell #\(indexPath.row)!")
    songs[indexPath.row].isSelected = true
    submitButton.isEnabled = true
    selectedRow = indexPath.row
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    NSLog("You deselected cell #\(indexPath.row)!")
    songs[indexPath.row].isSelected = false
  }
  
  
  @IBAction func submit(_ sender: UIButton) {
    do {
      let song : Song = songs[selectedRow]
      let data = ("Vote: " + song.title).data(using: .utf8)!
      do {
        try session.mcSession.send(data, toPeers: session.mcSession.connectedPeers, with: .reliable)
      } catch let error as NSError {
        let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
      }
    } catch {}
    performSegue(withIdentifier: "pollToGuest", sender: self)
  }

  @IBAction func backPressed(_ sender: Any) {
    performSegue(withIdentifier: "pollToGuest", sender: self)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier! {
    case "pollToGuest":
      let destination = segue.destination as! GuestViewController
      destination.session = self.session
      destination.song = self.currentSong
      submitButton.isEnabled = false
      NSLog("Segue to Guest Page")
    default:
      NSLog("Unknown segue identifier: \(segue.identifier!)")
    }
  }
}
