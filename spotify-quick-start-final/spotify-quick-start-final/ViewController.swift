//
//  ViewController.swift
//  spotify-quick-start-final
//
//  Created by Keegan Hanes on 3/15/19.
//  Copyright © 2019 Keegan Hanes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate  {
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://spotify-quick-start-final.herokuapp.com/api/token"),
            let tokenRefreshURL = URL(string: "https://spotify-quick-start-final.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(connectLabel)
        view.addSubview(connectButton)
        view.addSubview(imageView)
        view.addSubview(hostButton)
        view.addSubview(guestButton)
        let constant: CGFloat = 16.0

        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        imageView.bottomAnchor.constraint(equalTo: hostButton.topAnchor, constant: -10).isActive = true
        
        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        connectButton.sizeToFit()
        connectButton.addTarget(self, action: #selector(didTapConnect(_:)), for: .touchUpInside)
        
        connectLabel.centerXAnchor.constraint(equalTo: connectButton.centerXAnchor).isActive = true
        connectLabel.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -constant).isActive = true
        
        hostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hostButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hostButton.sizeToFit()
        hostButton.addTarget(self, action: #selector(didTapHost(_:)), for: .touchUpInside)
        hostButton.isHidden = true
        
        guestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guestButton.topAnchor.constraint(equalTo: hostButton.topAnchor, constant: 60).isActive = true
        guestButton.sizeToFit()
        guestButton.addTarget(self, action: #selector(didTapGuest(_:)), for: .touchUpInside)
        guestButton.isHidden = true
    }
    
    @objc func didTapConnect(_ button: UIButton) {
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        if #available(iOS 11, *) {
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        } else {
            sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
        }
    }
    
    @objc func didTapHost(_ button: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let hostVC = storyboard.instantiateViewController(withIdentifier: "HostViewController") as! HostViewController
        self.navigationController?.pushViewController(hostVC, animated: true)
    }
    
    @objc func didTapGuest(_ button: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let guestVC = storyboard.instantiateViewController(withIdentifier: "GuestViewController") as! GuestViewController
        self.navigationController?.pushViewController(guestVC, animated: true)
    }
    
}

