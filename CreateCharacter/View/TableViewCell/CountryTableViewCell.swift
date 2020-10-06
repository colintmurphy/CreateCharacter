//
//  CountryTableViewCell.swift
//  CreateCharacter
//
//  Created by Colin Murphy on 9/24/20.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var countryNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(title: String) {
        self.countryNameLabel.text = title
    }
}
