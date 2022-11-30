//
//  ComicCollectionViewCell.swift
//  MarvelAssignment
//
//  Created by omaestra on 28/11/22.
//

import UIKit
import Kingfisher

class ComicCollectionViewCell: UICollectionViewCell, NibLoadableView & ReusableView {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueDateLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with comic: Comic) {
        if let imageUrl = comic.thumbnail?.url, let url = URL(string: imageUrl) {
            self.thumbnailImageView.kf.indicatorType = .activity
            self.thumbnailImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = comic.title
        formatLabel.text = "#\(comic.issueNumber ?? 0)"
        
        if let modified = comic.modified {
            issueDateLabel.isHidden = false
            
            let formatter = ISO8601DateFormatter()
            let date = formatter.date(from: modified)
            issueDateLabel.text = date?.formatted()
        } else {
            issueDateLabel.isHidden = true
        }
    }
}
