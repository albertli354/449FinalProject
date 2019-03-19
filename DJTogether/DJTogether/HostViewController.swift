//
//  HostViewController.swift
//  DJTogether
//
//  Created by cse-loaner on 3/18/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import UIKit

class HostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SPTAppRemotePlayerStateDelegate {

    @IBAction func pauseButtonClicked(_ sender: Any) {
        appRemote.playerAPI?.pause(defaultCallback)
    }
    
    fileprivate func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayError(_ error: NSError?) {
        if let error = error {
            presentAlert(title: "Error", message: error.description)
        }
    }
    
    var defaultCallback: SPTAppRemoteCallback {
        get {
            return {[weak self] _, error in
                if let error = error {
                    self?.displayError(error as NSError)
                }
            }
        }
    }
    
    var appRemote: SPTAppRemote {
        get {
            return AppDelegate.sharedInstance.appRemote
        }
    }
    
    fileprivate var lastPlayerState: SPTAppRemotePlayerState?
    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            
        }
        lastPlayerState = playerState
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }
    
    
    
    
    
    
  @IBOutlet weak var createPollButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  var songs = [Song("Mr. Blue Sky", "spotify:track:2RlgNHKcydI9sayD2Df2xp"),
               Song("Come a Little Bit Closer", "spotify:track:252YuUdUaC5OojaBU0H1CP"),
               Song("Bohemian Rhapsody", "spotify:track:7tFiyTwD0nx5a1eklYtX2J")]
  var session : Session!
    var selectedSong = Song("", "")

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.appRemote.playerAPI?.delegate = self
    self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
        if let error = error {
            debugPrint(error.localizedDescription)
        }
    })

        // Do any additional setup after loading the view.
    NSLog("Host view loaded")
    tableView.allowsSelection = true
    tableView.allowsMultipleSelection = false
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    NSLog("Table view count: " + String(songs.count))
    return songs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    NSLog("Table view cell at index: " + String(indexPath.row))
    let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
    cell.song = songs[indexPath.row]
    cell.voteLabel.isHidden = true
    return cell
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell #\(indexPath.row)!")
        selectedSong = songs[indexPath.row]
        for song in songs {
            if (selectedSong.title == song.title) {
                self.appRemote.playerAPI?.play(song.URI, callback: { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                })
            }
        }
    }

  @IBAction func buttonPressed(_ sender: UIButton) {
    switch sender {
    case createPollButton:
      performSegue(withIdentifier: "hostToPoll", sender: self)
    default:
      NSLog("Unrecognized button pressed")
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier! {
    case "hostToPoll":
      let destination = segue.destination as! HostPollViewController
      destination.session = session
      destination.songs = songs
      NSLog("Segue to Host Poll page")
    default:
      NSLog("Unknown segue identifier: \(segue.identifier!)")
    }
  }
  
  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
