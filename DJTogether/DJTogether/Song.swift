//
//  Song.swift
//  DJTogether
//
//  Created by cse-loaner on 3/18/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import Foundation

class Song : Codable {
  var title: String
  var URI: String
  var isSelected = false
  var votes: Int
  
  init(_ title : String, _ URI : String) {
    self.title = title
    self.URI = URI
    votes = 0
  }
  
  init(_ title : String, _ URI : String, isSelected : Bool, votes : Int) {
    self.title = title
    self.URI = URI
    self.isSelected = isSelected
    self.votes = votes
  }
}
