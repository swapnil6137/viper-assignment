//
//  ProductResponse.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import Foundation
struct ProductResponse: Decodable {
	let products: [Product]?
	let pagination: Pagination?

	enum CodingKeys: String, CodingKey {
		case products = "data"
		case pagination
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
		pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)
	}

}
