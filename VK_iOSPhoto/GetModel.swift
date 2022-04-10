//
//  GetModels.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 06.04.2022.
//

import Foundation

struct GetModel {
    let urlPhoto: String
    
    init(info: PhotoItems) {
        urlPhoto = info.sizes[3].url
    }
}

