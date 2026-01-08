//
//  APIHelper.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//
import Foundation

struct APIConfig {
    static let baseUrl: String = "https://fakeapi.net"
}

struct APIEndPoints {
    static let PRODUCTS = APIEndPoint.init(endPoint: "/products", method: .get)
}
