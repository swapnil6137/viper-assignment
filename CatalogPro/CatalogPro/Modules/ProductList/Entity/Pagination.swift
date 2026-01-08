//
//  Pagination.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import Foundation
struct Pagination: Codable {
	let page: Int?
	let limit: Int?
	let total: Int?

	enum CodingKeys: String, CodingKey {
		case page
		case limit
		case total
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		limit = try values.decodeIfPresent(Int.self, forKey: .limit)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
	}

}
