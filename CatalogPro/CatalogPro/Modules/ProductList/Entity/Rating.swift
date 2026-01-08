//
//  Rating.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import Foundation
struct Rating: Codable {
	let rate: Double?
	let count: Int?

	enum CodingKeys: String, CodingKey {
		case rate
		case count
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		rate = try values.decodeIfPresent(Double.self, forKey: .rate)
		count = try values.decodeIfPresent(Int.self, forKey: .count)
	}

}
