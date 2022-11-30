//
//  CharactersListPresenterTests.swift
//  MarvelAssignmentTests
//
//  Created by omaestra on 30/11/22.
//

import XCTest
@testable import MarvelAssignment

class CharactersListPresenterTests: XCTestCase {
    
    var presenter: CharactersListPresenterProtocol!

    override func setUpWithError() throws {
        let mockNetworking = MockNetworking()
        let service: CharacterServiceProtocol = CharacterService(network: mockNetworking)
        presenter = CharactersListPresenter(service: service)
    }
    
    func testFetchCharacters() throws {
        XCTAssertTrue(presenter.characters?.isEmpty ?? false)
        
        presenter.fetchCharacters()
        
        XCTAssertNotNil(presenter.characters)
        XCTAssertEqual(presenter.numberOfRows(), 2)
    }
    
    func testGetCharacter() throws {
        presenter.fetchCharacters()
        
        let character = presenter.getCharacter(at: IndexPath(row: 1, section: 0))
        XCTAssertEqual(character?.id, 1017100)
        XCTAssertEqual(character?.name, "A-Bomb (HAS)")
    }
    
    func testSearchCharactersByname() throws {
        presenter.isSearching = true
        
        XCTAssertNil(presenter.searchResults)
        presenter.searchCharacters(text: "3-D M")
        XCTAssertNotNil(presenter.searchResults)
        
        XCTAssertEqual(presenter.numberOfRows(), 1)
    }
}
