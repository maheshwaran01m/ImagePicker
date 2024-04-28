//
//  EditFormViewModel.swift
//  ImagePicker
//
//  Created by MAHESHWARAN on 27/04/24.
//

import SwiftUI

@Observable
class EditFormViewModel {
  
  var name: String = ""
  var data: Data?
  
  var item: ImageItem?
  
  var cameraImage: UIImage? {
    didSet {
      updateImage()
    }
  }
  
  init() { }
  
  init(_ record: ImageItem) {
    name = record.name
    data = record.data
    item = record
  }
  
  var image: UIImage {
    guard let data, let image = UIImage(data: data) else {
      return Constants.placeholder
    }
    return image
  }
  
  @MainActor
  func clearImage() {
    data = .none
  }
  
  var isUpdating: Bool {
    item != nil
  }
  
  var isDisabled: Bool {
    name.isEmpty
  }
  
  private func updateImage() {
    guard let cameraImage else { return }
    data = cameraImage.jpegData(compressionQuality: 0.8)
    self.cameraImage = nil
  }
}

enum ModelFormType: Identifiable, View {
  case new
  case update(ImageItem)
  
  var id: String { String(describing: self) }
  
  var body: some View {
    switch self {
    case .new: EditFormView(.init())
    case .update(let imageItem): EditFormView(.init(imageItem))
    }
  }
}
