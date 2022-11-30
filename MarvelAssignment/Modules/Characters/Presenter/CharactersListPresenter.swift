//
//  CharactersListPresenter.swift
//  MarvelAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation

protocol CharactersListPresenterProtocol: AnyObject {
    var view: CharactersListViewProtocol? { get set }
    var characters: [Character]? { get }
    var searchResults: [Character]? { get set }
    var isSearching: Bool { get set }
    var service: CharacterServiceProtocol { get }
    
    func fetchCharacters()
    func getCharacter(at indexPath: IndexPath) -> Character?
    func searchCharacters(text: String)
    
    func numberOfRows() -> Int
}

class CharactersListPresenter: CharactersListPresenterProtocol {
    var characters: [Character]? = []
    var searchResults: [Character]?
    
    internal var service: CharacterServiceProtocol
    
    weak internal var view: CharactersListViewProtocol?
    
    private var fetchInProgress = false
    private var offset = 0
    private var limit = 20
    var isSearching = false
    
    init(service: CharacterServiceProtocol) {
        self.service = service
    }
    
    func fetchCharacters() {
        isSearching = false
        
        guard !fetchInProgress else {
            return
        }
        
        fetchInProgress = true
        
        service.fetchCharacters(offset: self.offset, limit: self.limit) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.offset += 20
                self?.fetchInProgress = false
                self?.characters?.append(contentsOf: characters)
                
                DispatchQueue.main.async {
                    self?.view?.reload()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.fetchInProgress = false
                    self?.characters = nil
                    self?.view?.displayError()
                }
            }
        }
    }
    
    func searchCharacters(text: String) {
        isSearching = !text.isEmpty
        
        guard !fetchInProgress else {
            return
        }
        
        fetchInProgress = true
        
        service.searchCharacters(by: text) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.fetchInProgress = false
                self?.searchResults = characters
                
                DispatchQueue.main.async {
                    self?.view?.reload()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.fetchInProgress = false
                    self?.searchResults = nil
                    self?.view?.displayError()
                }
            }
        }
    }
    
    func getCharacter(at indexPath: IndexPath) -> Character? {
        if isSearching {
            return searchResults?[indexPath.row]
        } else {
            return characters?[indexPath.row]
        }
    }
    
    func numberOfRows() -> Int {
        if isSearching {
            return searchResults?.count ?? 0
        } else {
            return characters?.count ?? 0
        }
    }
}
