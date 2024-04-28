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

// MARK: - ModelContext

extension ModelContext {
  
  func deleteAndSave<T: PersistentModel>(_ model: T) {
    delete(model)
    try? save()
  }
  
  func saveContext() {
    try? save()
  }
}

extension ModelContainer {
  
  @MainActor
  func fetchObjects<T: PersistentModel>(
    predicate: Predicate<T>? = nil, sort: [SortDescriptor<T>] = []) -> [T] {
      do {
        let fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        
        return try mainContext.fetch(fetchDescriptor)
      } catch {
        return []
      }
    }
  
  func fetchObjects<T: PersistentModel>(
    predicate: Predicate<T>? = nil, sort: [SortDescriptor<T>] = [], context: ModelContext) -> [T] {
      do {
        let fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        
        return try context.fetch(fetchDescriptor)
      } catch {
        return []
      }
    }
}
