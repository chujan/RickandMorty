//
//  RMService.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 26/02/2023.
//

import Foundation
final class RMService {
static let shared = RMService()
    
    private let cacheManager = RMAPICacheManager()
private init() {}
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    

    public func excute<T: Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping(Result<T, Error>) -> Void) {
        
        if let cacheData = cacheManager.cacheResponse(for: request.endpoint, url: request.url) {
            print("Using cached API Response")
            do {
                let result = try JSONDecoder().decode(type.self, from: cacheData)
                completion(.success(result))
                
            }
            catch {
                completion(.failure(error))
            }
           
            return
        }
        
        guard let urlRequest  = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        print("API Call: \(request.url?.absoluteString ?? "")")
        let task  = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
             
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            }
                catch {
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
    

    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
        
    }
}

