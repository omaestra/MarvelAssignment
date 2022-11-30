//
//  CharacterService.swift
//  MarvelAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation

protocol CharacterServiceProtocol {
    var network: NetworkingProtocol { get }
    
    func fetchCharacters(offset: Int?, limit: Int?, completion: @escaping (Result<[Character], Error>) -> Void)
    func getCharacter(characterId: Int, completion: @escaping (Result<Character, Error>) -> Void)
    func getComics(for character: Character, completion: @escaping (Result<[Comic], Error>) -> Void)
    func searchCharacters(by text: String, completion: @escaping (Result<[Character], Error>) -> Void)
}

final class CharacterService: CharacterServiceProtocol {
    var network: NetworkingProtocol
    
    init(network: NetworkingProtocol) {
        self.network = network
    }
    
    func fetchCharacters(offset: Int?, limit: Int?, completion: @escaping (Result<[Character], Error>) -> Void) {
        network.fetch(.characters(offset: offset, limit: limit)) { (result: Result<[Character], Error>) in
            switch result {
            case .success(let characters):
                completion(.success(characters))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCharacter(characterId: Int, completion: @escaping (Result<Character, Error>) -> Void){
        network.fetch(.characterDetails(id: characterId)) { (result: Result<Character, Error>) in
            switch result {
            case .success(let character):
                completion(.success(character))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getComics(for character: Character, completion: @escaping (Result<[Comic], Error>) -> Void) {
        network.fetch(.characterComics(characterId: character.id)) { (result: Result<[Comic], Error>) in
            switch result {
            case .success(let comics):
                completion(.success(comics))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchCharacters(by text: String, completion: @escaping (Result<[Character], Error>) -> Void) {
        network.fetch(.searchCharacters(text: text)) { (result: Result<[Character], Error>) in
            switch result {
            case .success(let characters):
                completion(.success(characters))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
