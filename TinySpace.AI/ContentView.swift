struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showRoomView = false
    @State private var roomWidth: String = ""
    @State private var roomDepth: String = ""
    @State private var roomHeight: String = "2.5" // Default height

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                VStack(spacing: 5) {
                    Text("Tiny Space")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Let AI do the furnishing")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                Spacer()

                // Room Dimensions Form
                VStack {
                    TextField("Room Width (meters)", text: $roomWidth)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)

                    TextField("Room Depth (meters)", text: $roomDepth)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    TextField("Room Height (meters)", text: $roomHeight)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Upload Room Photo")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }

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
            if let image = selectedImage, let width = Double(roomWidth), let depth = Double(roomDepth), let height = Double(roomHeight) {
                RoomDesignView(roomImage: image, roomDimensions: (width, depth, height))
            }
        }
    }
}
