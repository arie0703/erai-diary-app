//
//  ImagePicker.swift
//  SwiftApp
//
//  Created by 有村海星 on 2021/02/06.
//  Copyright © 2021 Kaisei Arimura. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    // MARK: - Working with UIViewControllerRepresentable
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator  // Coordinater to adopt UIImagePickerControllerDelegate Protcol.
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    // MARK: - Using Coordinator to Adopt the UIImagePickerControllerDelegate Protocol
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        
        
        
        /*
        func saveImage(image:UIImage,fileName:String)->Bool{
            //pngで保存する場合
            let pngImageData = image.pngData()

            let documentsURL = FileManager.default.urls(for:.documentDirectory,in:.userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            do{
                try pngImageData!.write(to:fileURL)
            }catch{
                //エラー処理
                return false
            }
            UserDefaults.standard.set(fileURL, forKey: "image")
            return true
            
        } */

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            //saveImage(image: parent.selectedImage, fileName: "user_image")
            UserDefaults.standard.setUIImageToData(image: parent.selectedImage, forKey: "image")
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
