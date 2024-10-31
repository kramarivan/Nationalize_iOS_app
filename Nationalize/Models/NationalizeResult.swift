//
//  NationalizeResult.swift
//  Nationalize
//
//  Created by Ivan Kramar on 31.10.2024..
//


struct NationalizeResult: Decodable {
    let count: Int
    let name: String
    let country: [Country]
}