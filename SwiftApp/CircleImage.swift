//
//  CircleImage.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/28.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .frame(width:150.0, height:150.0)
            .shadow(radius: 2)
            
    }
}
 
struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("noicon"))
    }
}
