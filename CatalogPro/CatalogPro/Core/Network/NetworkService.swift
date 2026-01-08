//
//  Untitled.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endPoint: APIEndPoint, completion: @escaping (Result<T, APIError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    init() {}
    
    private let urlSession: URLSession = URLSession.shared
    
    func request<T: Decodable>(endPoint: APIEndPoint, completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = endPoint.url() else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        
        if let parameters = endPoint.bodyParams {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.other(error)))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
                completion(.failure(APIError.invalidStatusCode))
                return
            }
        
            guard let data = data else {
                completion(.failure(APIError.dataIsNil))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
                
            } catch is DecodingError {
                completion(.failure(.decodingError))
            } catch {
                    completion(.failure(.invalidResponse))
            }
        }
        task.resume()
    }
}
