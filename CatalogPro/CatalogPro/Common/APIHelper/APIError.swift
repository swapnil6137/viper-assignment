//
//  APIError.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case decodingError
    case other(Error)
    case noInternetConnection
    case failedWithStatusCode(Int)
    case invalidStatusCode
    case dataIsNil
    case unAuthorizedDomain
    case invalidResponse
    
    var description: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .decodingError: return "Decoding Error"
        case .other(let error): return error.localizedDescription
        case .noInternetConnection: return "No Internet Connection"
        case .failedWithStatusCode(let code): return "Failed with status code: \(code)"
        case .invalidStatusCode: return "Failed with invalid status code."
        case .dataIsNil: return "Nil data received from API."
        case .unAuthorizedDomain: return "Unauthorized Domain."
        case .invalidResponse: return "Invalid Response."
        }
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.description == rhs.description
    }
}
