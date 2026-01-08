//
//  Product.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import Foundation
struct Product: Codable, Sendable {
	let id: Int?
	let title: String?
	let price: Double?
	let description: String?
	let category: String?
	let brand: String?
	let stock: Int?
	let image: String?
	let specs: Specs?
	let rating: Rating?

	enum CodingKeys: String, CodingKey {

		case id
		case title
		case price
		case description
		case category
		case brand
		case stock
		case image
		case specs
		case rating
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		price = try values.decodeIfPresent(Double.self, forKey: .price)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		category = try values.decodeIfPresent(String.self, forKey: .category)
		brand = try values.decodeIfPresent(String.self, forKey: .brand)
		stock = try values.decodeIfPresent(Int.self, forKey: .stock)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		specs = try values.decodeIfPresent(Specs.self, forKey: .specs)
		rating = try values.decodeIfPresent(Rating.self, forKey: .rating)
	}

}
