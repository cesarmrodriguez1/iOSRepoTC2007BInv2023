//
//  Fruit.swift
//  CollectionViewJSON
//
//  Created by César Manuel on 10/01/23.
//

import Foundation
import UIKit

//MODEL:

struct Fruit: Codable{
    let name: String
    let image: String
    let price: Int
}

struct Fruits: Codable{
    var fruits: [Fruit]
}
