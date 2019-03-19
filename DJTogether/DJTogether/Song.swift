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
  var img: String
  
  init(_ title : String, _ URI : String, _ img : String) {
    self.title = title
    self.URI = URI
    self.img = img
    votes = 0
  }
  
  init(_ title : String, _ URI : String, _ img : String, isSelected : Bool, votes : Int) {
    self.title = title
    self.URI = URI
    self.img = img
    self.isSelected = isSelected
    self.votes = votes
  }
}
