//
//  CharacterDetailsPresenter.swift
//  MarvelAssignment
//
//  Created by omaestra on 4/4/22.
//

import Foundation

protocol CharacterDetailsPresenterProtocol {
    var view: CharacterDetailsViewProtocol? { get set }
    var character: Character! { get }
    var comics: [Comic]? { get }
    var service: CharacterServiceProtocol { get }
    
    func getComicsDetails()
    func getComic(at indexPath: IndexPath) -> Comic?
}

class CharacterDetailsPresenter: CharacterDetailsPresenterProtocol {
    var view: CharacterDetailsViewProtocol?
    
    var character: Character!
    var comics: [Comic]?
    
    var service: CharacterServiceProtocol
    
    init(service: CharacterServiceProtocol = CharacterService(network: AlamofireNetworking())) {
        self.service = service
    }
    
    func getComicsDetails() {
        guard let character = self.character else {
            return
        }
        
        service.getComics(for: character) { [weak self] result in
            switch result {
            case .success(let comics):
                self?.comics = comics
                self?.view?.updateView(with: comics)
            case .failure:
                self?.comics = nil
                break
            }
        }
    }
    
    func getComic(at indexPath: IndexPath) -> Comic? {
        return comics?[indexPath.row]
    }
}
