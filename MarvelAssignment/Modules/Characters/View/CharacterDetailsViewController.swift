//
//  CharacterDetailsViewController.swift
//  MarvelAssignment
//
//  Created by omaestra on 3/4/22.
//

import UIKit
import Kingfisher
import Hero

protocol CharacterDetailsViewProtocol: AnyObject {
    func updateView(with comics: [Comic])
}

class CharacterDetailsViewController: UIViewController {
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var modifiedDateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var overviewStackView: UIStackView!
    @IBOutlet weak var comicsStackView: UIStackView!
    @IBOutlet weak var urlsStackView: UIStackView!
    @IBOutlet weak var comicsCollectionView: UICollectionView!
    
    var presenter: CharacterDetailsPresenterProtocol?
    weak private var navigator: CharactersNavigator?
    
    private var cellSize: CGSize {
        UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: 220, height: 320) : CGSize(width: 160, height: 265)
    }
    
    static func instantiate(character: Character, navigator: CharactersNavigator, service: CharacterServiceProtocol) -> CharacterDetailsViewController {
        let controller = CharacterDetailsViewController()
        let presenter = CharacterDetailsPresenter(service: service)
        presenter.character = character
        presenter.view = controller
        
        controller.presenter = presenter
        controller.navigator = navigator
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHero()
        
        setupNavigationBar()
        setupView()
        setupCollectionView()
        
        loadCharacterDetails()
        self.presenter?.getComicsDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.backgroundColor = nil
    }
    
    private func setupHero() {
        hero.isEnabled = true
        detailsContainerView.hero.modifiers = [.translate(y: 100)]
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func setupView() {
        detailsContainerView.layer.cornerRadius = 8.0
        detailsContainerView.layer.masksToBounds = true
        detailsContainerView.clipsToBounds = true
    }
    
    private func setupCollectionView() {
        comicsCollectionView.delegate = self
        comicsCollectionView.dataSource = self
        let nib: UINib = UINib(nibName: ComicCollectionViewCell.nibName, bundle: nil)
        comicsCollectionView.register(nib, forCellWithReuseIdentifier: ComicCollectionViewCell.reuseIdentifier)
    }
    
    private func createLinkTextView(text: String, url: String) -> UITextView {
        let textView = UITextView()
        textView.delegate = self
        let attributedString = NSMutableAttributedString(string: text.capitalized)
        let range = NSRange(location: 0, length: text.count)
        if let url = URL(string: url) {
            attributedString.setAttributes([.link: url], range: range)
        }
        
        textView.attributedText = attributedString
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        return textView
    }
}

extension CharacterDetailsViewController: CharacterDetailsViewProtocol {
    func loadCharacterDetails() {
        urlsStackView.subviews.forEach({ $0.removeFromSuperview() })
        self.titleLabel.text = presenter?.character?.name
        
        let modifiedDate = presenter?.character?.modified?.toAbbreviatedDateFormat()
        self.modifiedDateLabel.text = "Modified date: \(modifiedDate ?? "N/A")"
        
        self.descriptionTextView.text = presenter?.character?.description
        
        if let imageUrl = presenter?.character?.thumbnail?.url, let url = URL(string: imageUrl) {
            self.thumbnailImageView.kf.indicatorType = .activity
            self.thumbnailImageView.kf.setImage(with: url)
        }
        
        overviewStackView.isHidden = presenter?.character.description?.isEmpty ?? true
        
        overviewStackView.isHidden = presenter?.character.description?.isEmpty ?? true
        
        comicsStackView.isHidden = presenter?.comics?.isEmpty ?? true
        
        for item in presenter?.character.urls ?? [] {
            let textView = createLinkTextView(text: item.type.rawValue, url: item.url)
            urlsStackView.addArrangedSubview(textView)
        }
    }
    
    func updateView(with comics: [Comic]) {
        DispatchQueue.main.async {
            self.comicsCollectionView.reloadData()
            self.comicsStackView.isHidden = self.presenter?.comics?.isEmpty ?? true
        }
    }
}

extension CharacterDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 265)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCollectionViewCell.reuseIdentifier, for: indexPath) as! ComicCollectionViewCell
        
        guard let comic = presenter?.getComic(at: indexPath) else {
            return cell
        }
        
        cell.configure(with: comic)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let comic = self.presenter?.getComic(at: indexPath) else {
            return
        }
        
        navigator?.navigate(to: .comicDetails(comic: comic), navigationType: .overlay)
    }
}

extension CharacterDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
