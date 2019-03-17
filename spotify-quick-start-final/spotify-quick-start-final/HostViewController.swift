//
//  HostViewController.swift
//  spotify-quick-start-final
//
//  Created by Keegan Hanes on 3/16/19.
//  Copyright © 2019 Keegan Hanes. All rights reserved.
//

import UIKit

class HostViewController: UIViewController, SPTAppRemotePlayerStateDelegate {
    
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
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var pauseAndPlayButton: UIButton!
    @IBAction func rewindButtonPressed(_ sender: Any) {
        appRemote.playerAPI?.skip(toPrevious: defaultCallback)
    }
    @IBAction func skipSongButtonPressed(_ sender: Any) {
        appRemote.playerAPI?.skip(toNext: defaultCallback)
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
            pauseAndPlayButton.setTitle("PAUSE", for: .normal)
        } else {
            appRemote.playerAPI?.pause(nil)
            pauseAndPlayButton.setTitle("PLAY", for: .normal)
        }
    }
    
    var appRemote: SPTAppRemote {
        get {
            return AppDelegate.sharedInstance.appRemote
        }
    }
    
    func fetchArtwork(for track:SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                self?.albumArt.image = image
            }
        })
    }
    fileprivate var lastPlayerState: SPTAppRemotePlayerState?
    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        lastPlayerState = playerState
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
    }

}
