//
//  CharactersListTableTableViewController.swift
//  MarvelAssignment
//
//  Created by omaestra on 3/4/22.
//

import UIKit
import Hero

protocol CharactersListViewProtocol: AnyObject {
    func reload()
    func displayError()
}

class CharactersListTableTableViewController: UITableViewController {
    var presenter: CharactersListPresenterProtocol?
    private var navigator: CharactersNavigator?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var previousRun = Date()
    private let minInterval = 0.05
    
    private var searchTimer: Timer?
    
    private var cellHeight: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 250 : 160
    }
    
    static func instantiate(navigator: CharactersNavigator) -> CharactersListTableTableViewController {
        let controller = CharactersListTableTableViewController()
        let presenter = CharactersListPresenter(service: CharacterService(network: AlamofireNetworking()))
        presenter.view = controller
        
        controller.presenter = presenter
        controller.navigator = navigator
        
        return controller
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHero()
        
        configureTitle()
        configureNavigationBar()
        configureTableView()
        setupSearchBar()
        
        presenter?.fetchCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "marvelRed")
    }
    
    private func setupHero() {
        hero.isEnabled = true
        tableView.hero.modifiers = [.cascade]
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search by name"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor(named: "marvelRed")
        searchController.searchBar.tintColor = UIColor.white
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "marvelRed")
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationItem.titleView?.tintColor = .black
    }
    
    private func configureTitle() {
        title = "Characters"
        
        self.tableView.backgroundColor = UIColor(named: "marvelRed")
    }
    
    private func configureTableView() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refreshCharactersData(_:)), for: .valueChanged)
        
        let nib = UINib(nibName: CharacterTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        tableView.prefetchDataSource = self
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as! CharacterTableViewCell
        
        cell.hero.modifiers = [.fade]
        
        guard let character = presenter?.getCharacter(at: indexPath) else {
            return cell
        }
        
        cell.configureView(with: character)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let character = presenter?.getCharacter(at: indexPath) else {
            return
        }
        
        navigator?.navigate(to: .characterDetails(character: character), navigationType: .push)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    // MARK: - Actions
    
    @objc private func refreshCharactersData(_ sender: Any) {
        presenter?.fetchCharacters()
    }
}

extension CharactersListTableTableViewController: CharactersListViewProtocol {
    func displayError() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            
            let errorView = ErrorView(frame: self.view.frame)
            errorView.titleLabel.text = "There are no characters yet"
            errorView.descriptionLabel.text = nil
            self.tableView.backgroundView = errorView
        }
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        self.refreshControl?.endRefreshing()
    }
}

extension CharactersListTableTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        presenter?.fetchCharacters()
    }
}

extension CharactersListTableTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTimer?.invalidate()
        presenter?.searchResults?.removeAll()
        
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            presenter?.isSearching = false
            self.reload()
            return
        }

        // Debounce API call
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.presenter?.searchCharacters(text: textToSearch)
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.isSearching = false
        self.reload()
    }
}
