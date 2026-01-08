//
//  APIEndPoint.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum EndPointParams: String {
    case limit
    case page
    case category
}

struct APIEndPoint {
    var endPoint: String?
    var method: HTTPMethod = .get
    var queryParams: [String: String]?
    var bodyParams: [String: String]?
    var headers: [String: String]?
}

extension APIEndPoint {
    
    func url() -> URL? {
        guard let endPoint else {
            return nil
        }
        
        let baseUrl = APIConfig.baseUrl + "/" + endPoint
        return constructURL(baseURL: baseUrl, params: queryParams ?? [:])
    }
    
    func constructURL(baseURL: String, params: [String: String]) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
}
