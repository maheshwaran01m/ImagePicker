//
//  ImagePickerApp.swift
//  ImagePicker
//
//  Created by MAHESHWARAN on 27/04/24.
//

import SwiftUI
import SwiftData

@main
struct ImagePickerApp: App {
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: ImageItem.self)
  }
}
