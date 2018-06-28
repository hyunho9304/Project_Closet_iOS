//
//  Clothes.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 28..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct Clothes: Codable {
    
    let closet_memo: String?
    let closet_index: Int?
    let closet_image: String?
    let closet_uploadtime: String?
}

struct ClothesData: Codable {
    
    let status: String
    let data: [Clothes]?
    let message: String
}
