//
//  CharacterTableViewCell.swift
//  MarvelAssignment
//
//  Created by omaestra on 3/4/22.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell, ReusableView & NibLoadableView {
    
    var character: Character!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 6.0
        thumbnailImageView.layer.cornerRadius = 6.0
        thumbnailImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureView(with character: Character) {
        self.titleLabel.text = character.name
        if let imageUrl = character.thumbnail?.url, let url = URL(string: imageUrl) {
            self.thumbnailImageView.kf.indicatorType = .activity
            self.thumbnailImageView.kf.setImage(with: url)
        }
    }
}
