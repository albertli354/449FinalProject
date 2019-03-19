//
//  ViewController.swift
//  SearchSong
//
//  Created by Xiang Li on 3/16/19.
//  Copyright © 2019 xl52. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    var keywords = "Muse"
//    typealias JSONStandard

    
    let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json", "Authorization": "Bearer https://spotify-quick-start-final.herokuapp.com/api/token"]
    
//    https://api.spotify.com/v1/search?q=Muse&type=track&market=US&limit=10&offset=5
    @IBAction func clicked(_ sender: Any) {
        /*
        let scriptUrl = "https://api.spotify.com/v1/search?q=\(keywords)&type=track&market=US&limit=10&offset=5"
        let myUrl = NSURL(string: scriptUrl)
        let request  = NSMutableURLRequest(url: myUrl! as URL)
        request.addValue("https://spotify-quick-start-final.herokuapp.com/api/token", forHTTPHeaderField: "Authorization")
        //callAlamo(url: request)
        request.httpMethod = "GET"
 
        let searchUrl = NSURL(string: "https://api.spotify.com/v1/search?q=\(keywords)&type=track&market=US&limit=10&offset=5")
        let request = NSMutableURLRequest(url: searchUrl! as URL)
        request.addValue("https://spotify-quick-start-final.herokuapp.com/api/token", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
    */
 
        //let searchUrl = URL(string: "https://api.spotify.com/v1/search?q=\(keywords)&type=track&market=US&limit=10&offset=5")!
        
        let url = URL(string: "https://accounts.spotify.com/authorize?client_id=2e99b2e464ca4b6682d9872f8d89c0e1&response_type=code&redirect_uri=SearchSong://spotify-login-callback%2Fcallback&scope=user-read-private%20user-read-email&state=34fFs29kd09")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            if let res = response as? HTTPURLResponse {
                print("res: \(String(describing: res))")
                print("Response: \(String(describing: response))")
                print("data: \(String(describing: data))")
            }else{
                print("Error: \(String(describing: error))")
            }
            
        }
        task.resume()
        
        /*
        let session = URLSession.shared
        let authorizeString = "https://accounts.spotify.com/authorize?client_id=2e99b2e464ca4b6682d9872f8d89c0e1&response_type=code&redirect_uri=SearchSong://spotify-login-callback%2Fcallback&scope=user-read-private%20user-read-email&state=34fFs29kd09"
        let authorizeUrl = NSURL(string: authorizeString)
        let authorizeRequest = NSMutableURLRequest(url: authorizeUrl! as URL)
        authorizeRequest.httpMethod = "GET"
        let task = session.dataTask(with: authorizeRequest as URLRequest) { (data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
                print("res: \(String(describing: res))")
                print("Response: \(String(describing: response))")
                print("data: \(String(describing: data))")
                
                do {
                    //let readableJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : AnyObject]
                    //print(readableJSON as Any)
                }
                catch{
                    print(error)
                }
                
            }else{
                print("Error: \(String(describing: error))")
            }
        }
        task.resume()
 */
    }
    
    func getSong() {
        let session = URLSession.shared
        let string = "https://api.spotify.com/v1/search?q=\(keywords)&type=track&market=US&limit=10&offset=5"
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("Bearer https://searchsong.herokuapp.com//api/refresh_token", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
                //print("res: \(String(describing: res))")
                //print("Response: \(String(describing: response))")
                //print("data: \(String(describing: data))")
                
                do {
                    let readableJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : AnyObject]
                    print(readableJSON as Any)
                }
                catch{
                    print(error)
                }
                
            }else{
                print("Error: \(String(describing: error))")
            }
        }
        mData.resume()
    }
    
    /*
    func callAlamo(url : String) {
        AF.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData : Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as? [String : AnyObject]
            print(readableJSON as Any)
        }
        catch{
            print(error)
        }
    }
    */
 }
