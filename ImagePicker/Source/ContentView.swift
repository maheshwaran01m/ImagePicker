//
//  ContentView.swift
//  ImagePicker
//
//  Created by MAHESHWARAN on 27/04/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  
  @Query(sort: \ImageItem.name) var records: [ImageItem]
  @Environment(\.modelContext) private var modelContext
  
  @State private var formType: ModelFormType?
  
  var body: some View {
    NavigationStack {
      mainView
    }
  }
  
  private var mainView: some View {
    Group {
      if !records.isEmpty {
        listView
      } else {
        ContentUnavailableView("Add your Photo", systemImage: "photo")
      }
    }
    .toolbar(content: addButton)
    .navigationTitle("Image Picker")
  }
  
  private var listView: some View {
    List(records) { record in
      NavigationLink(value: record) {
        
        HStack {
          imageView(record)
          
          Text(record.name)
            .font(.headline)
        }
      }
      .swipeActions { deleteButton(record) }
    }
    .listStyle(.plain)
    .navigationDestination(for: ImageItem.self,
                           destination: destinationView)
  }

  private func destinationView(_ record: ImageItem) -> some View {
    DetailView(record: record)
  }
  
  @ViewBuilder
  private func imageView(_ record: ImageItem) -> some View {
    Group {
      if let image = record.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .frame(width: 50, height: 50)
          .clipShape(.rect(cornerRadius: 8))
          .padding(.trailing)
      } else {
        Image(systemName: "photo.fill")
          .resizable()
          .scaledToFill()
          .frame(width: 50, height: 50)
          .clipShape(.rect(cornerRadius: 8))
          .padding(.trailing)
      }
    }
  }
  
  private func deleteButton(_ record: ImageItem) -> some View {
    Button(role: .destructive) {
      modelContext.deleteAndSave(record)
    } label: {
      Image(systemName: "trash")
    }
  }
  
  private func addButton() -> some ToolbarContent {
    ToolbarItem(placement: .topBarTrailing) {
      Button {
        formType = .new
      } label: {
        Image(systemName: "plus")
          .imageScale(.large)
      }
      .sheet(item: $formType) { $0 }
    }
  }
}

// MARK: - Preview

#Preview {
  ContentView()
    .modelContainer(ImageItem.preview)
}
