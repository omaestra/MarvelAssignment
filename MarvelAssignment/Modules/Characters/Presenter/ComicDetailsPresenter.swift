//
//  ComicDetailsPresenter.swift
//  MarvelAssignment
//
//  Created by omaestra on 29/11/22.
//

import Foundation

protocol ComicDetailsPresenterProtocol {
    var view: ComicDetailsViewProtocol? { get set }
    var comic: Comic { get }
}

class ComicDetailsPresenter: ComicDetailsPresenterProtocol {
    
    var view: ComicDetailsViewProtocol?
    var comic: Comic
    
    init(comic: Comic) {
        self.comic = comic
    }
}
