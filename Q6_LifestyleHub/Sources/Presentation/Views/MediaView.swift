import SwiftUI
import AVKit
import PhotosUI

struct MediaView: View {
    @EnvironmentObject private var viewModel: MediaViewModel
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    GroupBox("Audio") {
                        Button {
                            viewModel.toggleAudio()
                        } label: {
                            Label(viewModel.isPlayingAudio ? "Pausar audio" : "Reproducir audio",
                                  systemImage: viewModel.isPlayingAudio ? "pause.circle.fill" : "play.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    GroupBox("Video") {
                        VStack(spacing: 10) {
                            VideoPlayer(player: viewModel.videoPlayer)
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Button {
                                viewModel.toggleVideo()
                            } label: {
                                Label(viewModel.isPlayingVideo ? "Pausar video" : "Reproducir video",
                                      systemImage: viewModel.isPlayingVideo ? "pause.circle.fill" : "play.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }

                    GroupBox("Imagen") {
                        VStack(spacing: 10) {
                            if let data = viewModel.selectedImageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 160)
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Label("Elegir imagen", systemImage: "photo")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Multimedia")
            .onChange(of: selectedItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        viewModel.selectedImageData = data
                    }
                }
            }
        }
    }
}
