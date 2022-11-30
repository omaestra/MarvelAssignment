//
//  ComicDetailsViewController.swift
//  MarvelAssignment
//
//  Created by omaestra on 29/11/22.
//

import UIKit

protocol ComicDetailsViewProtocol {}

class ComicDetailsViewController: UIViewController, ComicDetailsViewProtocol {

    @IBOutlet weak var thumbnailImageViewContainer: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var modifiedDateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var pageCountValueLabel: UILabel!
    @IBOutlet weak var formatValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var presenter: ComicDetailsPresenterProtocol?
    weak private var navigator: CharactersNavigator?
    
    static func instantiate(comic: Comic, navigator: CharactersNavigator) -> ComicDetailsViewController {
        let controller = ComicDetailsViewController()
        let presenter = ComicDetailsPresenter(comic: comic)
        presenter.view = controller
        
        controller.presenter = presenter
        
        controller.navigator = navigator
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupView()
    }
    
    private func setupImageView() {
        thumbnailImageViewContainer.layer.shadowColor = UIColor.black.cgColor
        thumbnailImageViewContainer.layer.shadowOpacity = 0.7
        thumbnailImageViewContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
        thumbnailImageViewContainer.layer.shadowRadius = 5
    }
    
    private func setupView() {
        if let imageUrl = presenter?.comic.thumbnail?.url, let url = URL(string: imageUrl) {
            self.thumbnailImageView.kf.indicatorType = .activity
            self.thumbnailImageView.kf.setImage(with: url)
        }
        titleLabel.text = presenter?.comic.title
        modifiedDateLabel.text = presenter?.comic.modified?.toAbbreviatedDateFormat()
        descriptionTextView.text = presenter?.comic.description
        pageCountValueLabel.text = "\(presenter?.comic.pageCount ?? 0)"
        formatValueLabel.text = presenter?.comic.format?.capitalized
        priceValueLabel.text = presenter?.comic.prices?.compactMap({ "$\($0.price)" }).joined(separator: " / ")
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
