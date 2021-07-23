//
//  CircleImage.swift
//  SwiftApp
//
//  Created by 有村海星 on 2020/11/28.
//  Copyright © 2020 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    
    // Data型で保存された画像をUIImage型に再変換。
    @State var image = UIImage(data: UserProfile().image)!
    @State private var isShowPhotoLibrary = false
    
    var body: some View {
        VStack {
            
            Image(uiImage: self.image)
            .resizable()
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .frame(width:130.0, height:130.0)
            .shadow(radius: 2)
            .onTapGesture {
                self.isShowPhotoLibrary = true
            }
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
