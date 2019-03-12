//
//  ViewController.swift
//  spotifyTest
//
//  Created by Keegan Hanes on 3/9/19.
//  Copyright © 2019 Keegan Hanes. All rights reserved.
//

import UIKit

var auth = SPTAuth.defaultInstance()
var session:SPTSession!
var loginUrl = URL.self

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth.redirectURL = URL(string: Spotify.redirectUrl)
        auth.clientID = Spotify.clientId
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserLibraryReadScope, SPTAuthUserFollowReadScope, SPTAuthUserReadTopScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
        NotificationCenter.default.addObserver(self, selector: #selector(spotifyLogin), name: NSNotification.Name(rawValue: "loginSuccess"), object: nil)
    }
}

