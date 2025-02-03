import SwiftUI
import SceneKit
import Vision

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showRoomView = false
    @State private var aiGeneratedLayouts: [String] = []
    @State private var showError = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 15) {
                Spacer()

                VStack(spacing: 5) {
                    Text("Tiny Space")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Let AI do the furnishing")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Upload Room Photos")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }

                Text("And we'll take care of the rest :)")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .padding(.top, 5)

                Spacer(minLength: 50)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if newImage != nil {
                showRoomView = true
            }
        }
        .fullScreenCover(isPresented: $showRoomView) {
            if let image = selectedImage {
                RoomDesignView(roomImage: image)
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text("Something went wrong. Please try again."), dismissButton: .default(Text("OK")))
        }
    }
}
