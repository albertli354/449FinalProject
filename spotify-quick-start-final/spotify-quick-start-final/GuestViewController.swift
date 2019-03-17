//
//  GuestViewController.swift
//  spotify-quick-start-final
//
//  Created by Keegan Hanes on 3/16/19.
//  Copyright © 2019 Keegan Hanes. All rights reserved.
//

import UIKit

class GuestViewController: UIViewController, SPTAppRemotePlayerStateDelegate {

    @IBAction func specificSongButtonPressed(_ sender: Any) {
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
