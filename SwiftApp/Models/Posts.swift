//
//  Posts.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/29.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct Posts: Hashable, Codable, Identifiable{
    var id: Int
    var content: String
    fileprivate var imageName: String
    
    
}

extension Posts {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}


