//
//  TableViewCell.swift
//  GitFind
//
//  Created by Артем Калинкин on 02.10.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var starLabel: UILabel!

  func fill(name: String, amountStars: Int) {
    nameLabel.text = name
    starLabel.text = "Stars: \(amountStars)"
  }
}
