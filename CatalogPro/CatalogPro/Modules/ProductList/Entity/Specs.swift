//
//  Specs.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import Foundation
struct Specs: Codable {
	let color: String?
	let weight: String?
	let storage: String?

	enum CodingKeys: String, CodingKey {
		case color
		case weight
		case storage
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		color = try values.decodeIfPresent(String.self, forKey: .color)
		weight = try values.decodeIfPresent(String.self, forKey: .weight)
		storage = try values.decodeIfPresent(String.self, forKey: .storage)
	}

}
