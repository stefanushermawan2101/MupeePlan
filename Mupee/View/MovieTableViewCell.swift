//
//  MovieTableViewCell.swift
//  Mupee
//
//  Created by Stefanus Hermawan Sebastian on 25/04/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var movieImageView: UIImageView! {
        didSet {
            movieImageView.layer.cornerRadius = 10.0
            movieImageView.clipsToBounds = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
