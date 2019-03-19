//
//  HostViewController.swift
//  DJTogether
//
//  Created by cse-loaner on 3/18/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import UIKit

class HostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SPTAppRemotePlayerStateDelegate {
  var session : Session!
  var selectedSong = Song("", "", "")

    @IBAction func pauseButtonClicked(_ sender: Any) {
        self.appRemote.playerAPI?.play("spotify:track:2gQYziDV5cSTRSqr6akzi5", callback: {(result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    var appRemote: SPTAppRemote {
        get {
            return AppDelegate.sharedInstance.appRemote
        }
    }
    fileprivate var lastPlayerState: SPTAppRemotePlayerState?
    func update(playerState: SPTAppRemotePlayerState) {
        lastPlayerState = playerState
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }
    
    
    
    
    
  @IBOutlet weak var createPollButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  var songs: [Song] = [Song("Mr. Blue Sky", "spotify:track:2RlgNHKcydI9sayD2Df2xp", "mr_blue_sky"),
               Song("Come a Little Bit Closer", "spotify:track:252YuUdUaC5OojaBU0H1CP", "come_a_little_bit_closer"),
               Song("Bohemian Rhapsody", "spotify:track:7tFiyTwD0nx5a1eklYtX2J", "bohemian_rhapsody.jpeg"),
               Song("Lake Shore Drive", "spotify:track:46MX86XQqYCZRvwPpeq4Gi", "lake_shore_drive"),
               Song("The Chain - 2004 Remaster", "spotify:track:5e9TFTbltYBg2xThimr0rU",
                    "the_chain"),
               Song("Bring It On Home To Me", "spotify:track:0WVTQp3SOCuMr08jh1jweV", "bring_it_on_home_to_me"),
               Song("Southern Nights", "spotify:track:7kv7zBjMtVf0eIJle2VZxn", "southern_nights"),
               Song("My Sweet Lord", "spotify:track:0qdQUeKVyevrbKhAo0ibxS", "my_sweet_lord"),
               Song("Brandy (You're A Fine Girl)", "spotify:track:2BY7ALEWdloFHgQZG6VMLA", "brandy"),
               Song("Father And Son", "spotify:track:19slC7k8bsPOAKDjHYLU2W", "father_and_son"),
               Song("Wham Bang Shang-A-Lang", "spotify:track:3qrEG6rQ9Qm72MNWeUKKiU", "wham_bam"),
               Song("Surrender", "spotify:track:2ccUQnjjNWT0rsNnsBpsCA", "wham_bam"),
               Song("Don't Stop Me Now - Remastered", "spotify:track:7hQJA50XrCWABAu5v6QZ4i", "don't_stop_me"),
               Song("Flashlight", "spotify:track:6Ie9yuocD61v7hrh02moc6", "flashlight"),
               Song("The Rubberband Man", "spotify:track:13Mzsb8VzRSZ5w3pM48cn6", "the_rubberband_man"),
               Song("Go All The Way", "spotify:track:75GQIYnRaBg7ndHxhfYuQy", "go_all_the_way"),
               Song("Hooked On A Feeling", "spotify:track:6Ac4NVYYl2U73QiTt11ZKd", "hooked_on_a_feeling"),
               Song("Fooled Around And Fell In Love", "spotify:track:2hE5Lm5XOHR4t3xlhIFauP", "fooled_around"),
               Song("Sprit In The Sky", "spotify:track:1CnTAkLCWL8Uvsr1BDiX8F", "spirit"),
               Song("Moonage Daydream - 2012 Remastered Version", "spotify:track:3ziCNz5vq8pEeRZjPElfYR", "moonage_daydream"),
               Song("I Want You Back", "spotify:track:2OSfEYKhlSsLx6vn4O75RK", "i_want_you_back"),
               Song("Fox On The Run", "spotify:track:66gG8RzSA2sVQwME8e43wX", "fox_on_the_run"),
               Song("I'm Not In Love", "spotify:track:1A6Kwtsg3JWKU2KWM2udpM", "not_in_love"),
               Song("Come And Get Your Love", "spotify:track:2T43UrvAg60ubJVo5KQ3t7", "come_and_get_your_love"),
               Song("Cherry Bomb", "spotify:track:7cdnq45E9aP2XDStHg5vd7", "cherry_bomb"),
               Song("Escape (The Pina Colada Song)", "spotify:track:5IMtdHjJ1OtkxbGe4zfUxQ", "escape_pina_colada"),
               Song("O-o-h Child - Remastered", "spotify:track:74JdR9aXE6I74oS1BVRsvb", "o-o-h_child"),
               Song("Ain't No Mountain High Enough - Mono Version", "spotify:track:4njseCGxWeZUksjhrqkleT", "aint_no_mountain"),
               Song("The Boys Are Back In Town", "potify:track:43DeSV93pJPT4lCZaWZ6b1", "the_boys"),
               Song("Walk Away", "spotify:track:5vE4GSOjOXAEhSyizJD3CX", "walk_away"),
               Song("Funk #49", "spotify:track:1qqeqeRgn7DFn1LSOA9VBv", "walk_away"),
               Song("Shake Your Groove Thing", "spotify:track:7hzY0LHz8KdEr1PowHhbdu", "shake_your"),
               Song("I Will Survive - 1981 Re-recording", "spotify:track:7DD1ojeTUwnW65g5QuZw7X", "i_will_survive"),
               Song("Funk Funk", "spotify:track:2ettf7qywhnJuavMxZOsWh", "funk_funk"),
               Song("Joy To The World", "spotify:track:2ymeOsYijJz09LfKw3yM2x", "joy_to_the_world")]


    override func viewDidLoad() {
        super.viewDidLoad()
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })

    NSLog("Host view loaded")
    tableView.allowsSelection = true
    tableView.allowsMultipleSelection = false
    tableView.dataSource = self
    tableView.delegate = self
    
    createPollButton.layer.cornerRadius = 10
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
      self.appRemote.playerAPI?.play(selectedSong.URI, callback: { (result, error) in
        if let error = error {
            print(error.localizedDescription)
        }
      })
      do {
        let song = try JSONEncoder().encode(selectedSong)
        try session.mcSession.send(song, toPeers: session.mcSession.connectedPeers, with: .reliable)
      } catch {}
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
