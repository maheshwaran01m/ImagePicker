//
//  CameraPicker.swift
//  ImagePicker
//
//  Created by MAHESHWARAN on 27/04/24.
//

import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
  
  @Binding var selectedImage: UIImage?
  @Environment(\.dismiss) private var dismiss
  
  func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.sourceType = .camera
    } else {
      imagePicker.sourceType = .photoLibrary
    }
    imagePicker.delegate = context.coordinator
    return imagePicker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController, 
                              context: Context) {}
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  final class Coordinator: NSObject,
                           UIImagePickerControllerDelegate,
                           UINavigationControllerDelegate {
    
    private var parent: CameraPicker
    
    init(_ parent: CameraPicker) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, 
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
      guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
        return
      }
      parent.selectedImage = image
      parent.dismiss()
    }
  }
}
