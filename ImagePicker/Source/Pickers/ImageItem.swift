//
//  ImageItem.swift
//  ImagePicker
//
//  Created by MAHESHWARAN on 27/04/24.
//

import Foundation
import UIKit.UIImage
import SwiftData

@Model
class ImageItem {
  
  var name: String
  
  @Attribute(.externalStorage) var data: Data?
  
  init(name: String, data: Data? = nil) {
    self.name = name
    self.data = data
  }
  
  var image: UIImage? {
    guard let data else { return nil }
    return UIImage(data: data)
  }
}

extension ImageItem {
  
  @MainActor
  static var preview: ModelContainer {
    
    let container = try! ModelContainer(
      for: ImageItem.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    var samples: [ImageItem] {
      [.init(name: "Sample 1"), .init(name: "Sample 2"), .init(name: "Sample 3")]
    }
    samples.forEach { container.mainContext.insert($0) }
    
    return container
  }
}

// MARK: - Constants

enum Constants {
  
  static let placeholder = UIImage(systemName: "photo.fill") ?? .add
}
