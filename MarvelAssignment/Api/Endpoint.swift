//
//  Endpoint.swift
//  MarvelAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation
import Alamofire

enum Endpoint {
    case characters(offset: Int?, limit: Int?)
    case characterDetails(id: Int)
    case characterComics(characterId: Int)
    case searchCharacters(text: String)
}

extension Endpoint: URLRequestConvertible {
    // MARK: - Path
    
    private var path: String {
        switch self {
        case .characters, .searchCharacters:
            return "characters"
            
        case .characterDetails(id: let id):
            return "characters/\(id)"
            
        case .characterComics(let characterId):
            return "characters/\(characterId)/comics"
        }
    }
    
    // MARK: - HTTPMethod
    
    var method: HTTPMethod {
        switch self {
        case .characters, .characterDetails, .characterComics, .searchCharacters:
            return .get
        }
    }
    
    // MARK: - Parameters
    
    private var parameters: Parameters? {
        var params: Parameters? = [:]
        
        let timestamp = "\(Date().timeIntervalSince1970)"
        
        guard let apiPrivateKey = Bundle.main.infoDictionary?[Constants.marvelApiPrivateKeyPath] as? String else {
            print("[ERROR]: Error retrieving API keys")
            return nil
        }
        
        guard let apiPublicKey = Bundle.main.infoDictionary?[Constants.marvelApiPublicKeyPath] as? String else {
            print("[ERROR]: Error retrieving API keys")
            return nil
        }
        
        let md5 = (timestamp + apiPrivateKey + apiPublicKey).md5()
        
        params?[Constants.Parameters.apiKey] = apiPublicKey
        params?[Constants.Parameters.ts] = timestamp
        params?[Constants.Parameters.hash] = md5
        
        switch self {
        case .characters(let offset, let limit):
            if let offset = offset {
                params?["offset"] = offset
            }
            if let limit = limit {
                params?["limit"] = limit
            }
            
        case .searchCharacters(let text):
            params?["nameStartsWith"] = text
            
        case .characterDetails, .characterComics:
            break
        }
        
        return params
    }
    
    var encoding: URLEncoding {
        switch self {
        case .characters, .characterComics, .searchCharacters:
            return .queryString
        case .characterDetails:
            return .default
        }
    }
    
    var mockFileName: String {
        switch self {
        case .characters:
            return "characters"
        case .searchCharacters:
            return "searchCharacters"
        default:
            return ""
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
