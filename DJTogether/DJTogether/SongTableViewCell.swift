//
//  SongTableViewCell.swift
//  DJTogether
//
//  Created by cse-loaner on 3/18/19.
//  Copyright © 2019 info449DJ. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

  @IBOutlet weak var songLabel: UILabel!
  @IBOutlet weak var songImageView: UIImageView!
  @IBOutlet weak var voteLabel: UILabel!
  
  var songData : Song? {
    didSet {
      songLabel.text = songData!.title
      voteLabel.text = String(songData!.votes)
      songImageView.image = UIImage(named: songData!.img)
    }
  }
  
  var song: Song? {
    get { return songData }
    set { songData = newValue }
  }
  
  var img: UIImage {
    get { return songImageView.image! }
    set { songImageView.image = newValue }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
      accessoryType = selected ? .checkmark : .none
    }

}
