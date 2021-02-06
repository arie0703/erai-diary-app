//
//  CircleImage.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/28.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    
    @State private var image = UIImage()
    

    
    @State private var isShowPhotoLibrary = false
    
    var body: some View {
        VStack {
            if UserProfile().total_point >= 20 {
                Image("hiyoko")
                .resizable()
                //.scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 4))
                .frame(width:150.0, height:150.0)
                .shadow(radius: 2)
            } else {
                Image("Chicken")
                .resizable()
                //.scaledToFit()
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 4))
                .frame(width:150.0, height:150.0)
                .shadow(radius: 2)
            }
            
                
                /*
                .onTapGesture {
                    self.isShowPhotoLibrary = true
                }*/
            Text(UserProfile().image.description)
        }
        .sheet(isPresented: $isShowPhotoLibrary, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        })
    }
}
 
struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
