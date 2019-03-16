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

    
//    https://api.spotify.com/v1/search?q=Muse&type=track&market=US&limit=10&offset=5
    @IBAction func clicked(_ sender: Any) {
        let searchUrl = "https://api.spotify.com/v1/search?q=\(keywords)&type=track&market=US&limit=10&offset=5"
        callAlamo(url: searchUrl)
    }
    
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
    
    

}

