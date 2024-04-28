//
//  DetailView.swift
//  ImagePicker
//
//  Created by MAHESHWARAN on 27/04/24.
//

import SwiftUI
import SwiftData

struct DetailView: View {
  
  @SwiftUI.Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @State private var formType: ModelFormType?

  let record: ImageItem
  
  var body: some View {
    VStack {
      Text(record.name)
        .font(.largeTitle)
      
      imageView
      buttonView
    }
    .padding()
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("Detail")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  @ViewBuilder
  private var imageView: some View {
    Group {
      if let image = record.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          
      } else {
        Image(systemName: "photo.fill")
          .resizable()
          .scaledToFit()
      }
    }
    .clipShape(.rect(cornerRadius: 12))
  }

  
  private var buttonView: some View {
    HStack {
      Button("Edit") {
        formType = .update(record)
      }
      .sheet(item: $formType) { $0 }
      
      Button("Delete", role: .destructive) {
        modelContext.delete(record)
        dismiss()
      }
    }
    .padding(.horizontal)
    .buttonStyle(.borderedProminent)
    .frame(maxWidth: .infinity, alignment: .center)
  }
}

// MARK: - Preview

#Preview {
  
  return NavigationStack {
    DetailView(record: ImageItem.preview.fetchObjects()[0])
  }
}
