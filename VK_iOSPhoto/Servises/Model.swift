//
//  Model.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 06.04.2022.
//

import Foundation

struct Model: Decodable {
    var response: Items
}
struct Items: Decodable {
    var items: [PhotoItems]
}
struct PhotoItems: Decodable {
    var sizes: [Sizes]
}
struct Sizes: Decodable {
    var url: String
}
