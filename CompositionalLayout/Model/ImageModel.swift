//
//  ImageModel.swift
//  CompositionalLayout
//
//  Created by Claudius Kockelmann on 01.05.22.
//

import SwiftUI

struct ImageModel: Identifiable, Codable, Hashable {
    var id: String
    var download_url: String
    
    enum CodingKeys: String,CodingKey {
        case id
        case download_url
    }
}
