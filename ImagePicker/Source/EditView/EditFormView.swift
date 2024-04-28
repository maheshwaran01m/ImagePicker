//
//  EditFormView.swift
//  ImagePicker
//
//  Created by MAHESHWARAN on 27/04/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditFormView: View {
  
  @SwiftUI.Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  
  @State private var viewModel: EditFormViewModel
  
  @State private var imagePicker = ImagePicker()
  
  @State private var showCamera = false
  @State private var cameraError: CameraPermission.CameraError?
  
  init(_ viewModel: EditFormViewModel) {
    _viewModel = .init(initialValue: viewModel)
  }
  
  var body: some View {
    NavigationStack {
      
      Form {
        TextField("Name", text: $viewModel.name)
        
        VStack {
          if viewModel.data != nil {
            Button("Clear Image") { viewModel.clearImage() }
              .buttonStyle(.bordered)
          }
          
          HStack {
            Button("Camera", systemImage: "camera") {
              if let error = CameraPermission.checkPermissions() {
                cameraError = error
              } else {
                showCamera.toggle()
              }
            }
            .sheet(isPresented: $showCamera) {
              CameraPicker(selectedImage: $viewModel.cameraImage)
                .ignoresSafeArea()
            }
            
            PhotosPicker(selection: $imagePicker.imageSelection) {
              Label("Photos", systemImage: "photo")
            }
          }
          .buttonStyle(.borderedProminent)
          .foregroundStyle(.white)
          
          Image(uiImage: viewModel.image)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 12))
            .padding()
        }
      }
      .onAppear { imagePicker.setup(viewModel) }
      .toolbar(content: cancelButton)
      .alert(isPresented: .constant(cameraError != nil),
             error: cameraError) { _ in
        Button("OK") {
          cameraError = nil
        }
      } message: { error in
        Text(error.recoverySuggestion ?? "Try again later")
      }
    }
  }
  
  @ToolbarContentBuilder
  private func cancelButton() -> some ToolbarContent {
    ToolbarItem(placement: .topBarLeading) {
      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark.circle")
      }
      .foregroundStyle(Color.primary, Color.gray)
    }
    
    ToolbarItem(placement: .topBarTrailing) {
      Button {
        if viewModel.isUpdating,
           let item = viewModel.item {
          
          if viewModel.image != Constants.placeholder {
            item.data = viewModel.image.jpegData(compressionQuality: 0.8)
          }
          item.name = viewModel.name
          dismiss()
          
        } else {
          let item = ImageItem(name: viewModel.name)
          if viewModel.image != Constants.placeholder {
            item.data = viewModel.image.jpegData(compressionQuality: 0.8)
            
          }
          modelContext.insert(item)
          dismiss()
        }
      } label: {
        Text(viewModel.isUpdating ? "Update": "Add")
      }
      .disabled(viewModel.isDisabled)
      .buttonStyle(.borderless)
    }
  }
}

// MARK: - Preview

#Preview {
  EditFormView(.init())
}
