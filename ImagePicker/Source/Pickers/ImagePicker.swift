//
//  ImagePicker.swift
//  ImagePicker
//
//  Created by MAHESHWARAN on 27/04/24.
//

import SwiftUI
import PhotosUI

@Observable
class ImagePicker {
  
  var image: Image?
  var images: [Image] = []
  
  var vm: EditFormViewModel?
  
  func setup(_ vm: EditFormViewModel) {
    self.vm = vm
  }
  var imageSelection: PhotosPickerItem? {
    didSet {
      updateImage()
    }
  }
  
  func updateImage() {
    Task {
      do {
        if let data = try await imageSelection?.loadTransferable(
          type: Data.self),
           let image = UIImage(data: data) {
          await MainActor.run {
            vm?.data = data
            self.image = Image(uiImage: image)
          }
        }
      } catch {
        image = nil
      }
    }
  }
}
