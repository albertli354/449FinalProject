import UIKit

class ViewController: UIViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    // My Personal Spotify Client Id and Redirect URI for this app
    fileprivate let SpotifyClientID = "1e9baa3ac22043ee912168fd2979d122"
    fileprivate let SpotifyRedirectURI = URL(string: "spotify-quick-start-3://spotify-login-callback")!
    
    // Plays a song so that spotify can connect and uses my token swap url's
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        configuration.tokenSwapURL = URL(string: "https://spotify-quick-start-3.herokuapp.com/api/token")
        configuration.tokenRefreshURL = URL(string: "https://spotify-quick-start-3.herokuapp.com/api/refresh_token")
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    fileprivate var lastPlayerState: SPTAppRemotePlayerState?
    
    // ALL THE BUTTONSSSSSSS AND LABELLLLSSS
    
    @IBOutlet weak var albumArtwork: UIImageView!
    
    fileprivate lazy var connectLabel: UILabel = {
        let label = UILabel()
        label.text = "Connect your Spotify account"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var connectButton = ConnectButton(title: "CONNECT")
    //fileprivate lazy var disconnectButton = ConnectButton(title: "DISCONNECT")
    
    /*
    fileprivate lazy var pauseAndPlayButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapPauseOrPlay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // ********************** MY ADDED SKIP BUTTON ***********************************
    fileprivate lazy var skipButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // *******************************************************************************
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var trackLabel: UILabel = {
        let trackLabel = UILabel()
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.textAlignment = .center
        return trackLabel
    }()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(connectLabel)
        view.addSubview(connectButton)
        /*
        view.addSubview(disconnectButton)
        view.addSubview(imageView)
        view.addSubview(trackLabel)
        view.addSubview(pauseAndPlayButton)
        // My added skip button
        view.addSubview(skipButton)
        */
        let constant: CGFloat = 16.0
 
        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        /*
        disconnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        disconnectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        */
        
        connectLabel.centerXAnchor.constraint(equalTo: connectButton.centerXAnchor).isActive = true
        connectLabel.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -constant).isActive = true
        /*
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        imageView.bottomAnchor.constraint(equalTo: trackLabel.topAnchor, constant: -constant).isActive = true
        
        trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        trackLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: constant).isActive = true
        trackLabel.bottomAnchor.constraint(equalTo: connectLabel.topAnchor, constant: -constant).isActive = true
        
        pauseAndPlayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseAndPlayButton.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: constant).isActive = true
        pauseAndPlayButton.widthAnchor.constraint(equalToConstant: 50)
        pauseAndPlayButton.heightAnchor.constraint(equalToConstant: 50)
        pauseAndPlayButton.sizeToFit()
        
        // Figure out how to position this button bro
        skipButton.frame = CGRect(x: 30, y: 30, width: 5, height: 5)
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: constant).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 50)
        skipButton.heightAnchor.constraint(equalToConstant: 50)
        skipButton.sizeToFit()
        */
        
        connectButton.sizeToFit()
        // disconnectButton.sizeToFit()
        
        connectButton.addTarget(self, action: #selector(didTapConnect(_:)), for: .touchUpInside)
        // disconnectButton.addTarget(self, action: #selector(didTapDisconnect(_:)), for: .touchUpInside)
 
        updateViewBasedOnConnected()
    }
    
    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        lastPlayerState = playerState
        //trackLabel.text = playerState.track.name
        if playerState.isPaused {
            //pauseAndPlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            //pauseAndPlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    func updateViewBasedOnConnected() {
        if (appRemote.isConnected) {
            albumArtwork.isHidden = false
            /*
            connectButton.isHidden = true
            disconnectButton.isHidden = false
            connectLabel.isHidden = true
            imageView.isHidden = false
            trackLabel.isHidden = false
            pauseAndPlayButton.isHidden = false
            // My skip button
            skipButton.isHidden = false
            */
        } else {
            //let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            //let VC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            //self.navigationController?.pushViewController(VC, animated: true)
            //disconnectButton.isHidden = true
            connectButton.isHidden = false
            connectLabel.isHidden = false
            albumArtwork.isHidden = true
            //imageView.isHidden = true
            //trackLabel.isHidden = true
            //pauseAndPlayButton.isHidden = true
            // My skip button
            //skipButton.isHidden = true
        }
    }
    
    func fetchArtwork(for track:SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                self?.albumArtwork.image = image
            }
        })
    }
    
    func fetchPlayerState() {
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            }
        })
    }
    
    // MARK: - Actions
    
    @objc func didTapPauseOrPlay(_ button: UIButton) {
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
        } else {
            appRemote.playerAPI?.pause(nil)
        }
    }
    
    
    @objc func didTapDisconnect(_ button: UIButton) {
        if (appRemote.isConnected) {
            appRemote.disconnect()
        }
    }
    
    
    @objc func didTapConnect(_ button: UIButton) {
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        
        if #available(iOS 11, *) {
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        } else {
            sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
        }
    }
    
    
    // MARK: - SPTSessionManagerDelegate
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    // MARK: - SPTAppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        updateViewBasedOnConnected()
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        fetchPlayerState()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }
    
    // MARK: - SPTAppRemotePlayerAPIDelegate
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }
    
    // MARK: - Private Helpers
    
    fileprivate func presentAlertController(title: String, message: String, buttonTitle: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true)
    }
}

