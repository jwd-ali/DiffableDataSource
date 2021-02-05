//
//  Model.swift
//  CombinePractice
//
//  Created by Jawad Ali on 02/02/2021.
//  Copyright © 2021 Jawad Ali. All rights reserved.
//

import Foundation

// MARK: - Modal
struct Films: Decodable,Hashable {
    let searchType, expression: String?
    let results: [Result]?
    let errorMessage: String?
}

// MARK: - Result
struct Result: Decodable, Hashable {
    let id, resultType: String?
    let image: String?
    let title, resultDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, resultType, image, title
        case resultDescription = "description"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.id == rhs.id
    }
}
