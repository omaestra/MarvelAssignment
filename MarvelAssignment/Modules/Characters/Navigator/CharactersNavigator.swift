//
//  CharactersNavigator.swift
//  MarvelAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation
import UIKit

final class CharactersNavigator: Navigator {
    enum Destination {
        case charactersList
        case characterDetails(character: Character)
        case comicDetails(comic: Comic)
    }
    
    private weak var navigationController: UINavigationController?

    var rootViewController: UIViewController? {
        return navigationController
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Navigator
    
    func navigate(to destination: Destination, navigationType: NavigationType) {
        let viewController = makeViewController(for: destination)
        
        switch navigationType {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .overlay:
            navigationController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .charactersList:
            return CharactersListTableTableViewController.instantiate(navigator: self)
        case .characterDetails(let character):
            let service = CharacterService(network: AlamofireNetworking())
            return CharacterDetailsViewController.instantiate(character: character, navigator: self, service: service)
        case .comicDetails(let comic):
            return ComicDetailsViewController.instantiate(comic: comic, navigator: self)
        }
    }
}
