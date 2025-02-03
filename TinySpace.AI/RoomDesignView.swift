import SwiftUI
import SceneKit
import Vision

struct RoomDesignView: View {
    let roomImage: UIImage
    @State private var roomScene: SCNScene?
    @State private var wallColor: Color = .white
    @State private var selectedFurniture: String? = nil
    @Environment(\.presentationMode) var presentationMode
    
    let furnitureTypes = ["Sofa", "Chair", "Table", "Bed"]
    
    var body: some View {
        VStack {
            // Top navigation
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding()
                    Text("Back")
                        .foregroundColor(.white)
                }
                Spacer()
                Text("Room Design")
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
            }
            .background(Color.black)
            
            // Uploaded Image
            Image(uiImage: roomImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(10)
                .padding()
            
            // Wall Color Picker
            ColorPicker("Wall Color", selection: $wallColor)
                .padding()
                .onChange(of: wallColor) { newColor in
                    updateWallColor(newColor)
                }
            
            // 3D Room Visualization
            SceneView(scene: roomScene,
                      options: [.allowsCameraControl])
                .frame(height: 300)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
            
            // Furniture Selection Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(furnitureTypes, id: \.self) { furniture in
                        Button(action: {
                            selectedFurniture = furniture
                            placeFurniture(type: furniture)
                        }) {
                            Text(furniture)
                                .foregroundColor(.white)
                                .padding()
                                .background(selectedFurniture == furniture ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            
            // Action Buttons
            HStack {
                Button(action: {
                    generateAILayout()
                }) {
                    Text("AI Layout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    saveRoomDesign()
                }) {
                    Text("Save Design")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            setupRoomScene()
        }
    }
    
    func setupRoomScene() {
        let scene = SCNScene()
        
        // Create walls
        let wallWidth: CGFloat = 4.0
        let wallHeight: CGFloat = 2.5
        let wallThickness: CGFloat = 0.1
        
        let wallMaterial = SCNMaterial()
        wallMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
        
        // Floor
        let floorGeometry = SCNPlane(width: wallWidth, height: wallWidth)
        let floorNode = SCNNode(geometry: floorGeometry)
        floorNode.geometry?.materials = [wallMaterial]
        floorNode.rotation = SCNVector4(1, 0, 0, -CGFloat.pi/2)
        scene.rootNode.addChildNode(floorNode)
        
        // Four walls with basic setup
        let wallGeometries = [
            SCNPlane(width: wallWidth, height: wallHeight),
            SCNPlane(width: wallWidth, height: wallHeight),
            SCNPlane(width: wallWidth, height: wallHeight),
            SCNPlane(width: wallWidth, height: wallHeight)
        ]
        
        let wallPositions = [
            SCNVector3(0, wallHeight/2, -wallWidth/2),   // Back wall
            SCNVector3(0, wallHeight/2, wallWidth/2),    // Front wall
            SCNVector3(-wallWidth/2, wallHeight/2, 0),   // Left wall
            SCNVector3(wallWidth/2, wallHeight/2, 0)     // Right wall
        ]
        
        let wallRotations = [
            SCNVector4(0, 1, 0, 0),                     // Back wall
            SCNVector4(0, 1, 0, CGFloat.pi),            // Front wall
            SCNVector4(0, 1, 0, -CGFloat.pi/2),         // Left wall
            SCNVector4(0, 1, 0, CGFloat.pi/2)           // Right wall
        ]
        
        for (index, geometry) in wallGeometries.enumerated() {
            let wallNode = SCNNode(geometry: geometry)
            wallNode.geometry?.materials = [wallMaterial]
            wallNode.position = wallPositions[index]
            wallNode.rotation = wallRotations[index]
            scene.rootNode.addChildNode(wallNode)
        }
        
        // Add a simple camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 2, 5)
        scene.rootNode.addChildNode(cameraNode)
        
        roomScene = scene
    }
    
    func updateWallColor(_ color: Color) {
        guard let scene = roomScene else { return }
        
        // Update wall materials with new color
        scene.rootNode.childNodes.forEach { node in
            if let geometry = node.geometry, geometry is SCNPlane {
                let material = SCNMaterial()
                material.diffuse.contents = UIColor(color)
                node.geometry?.materials = [material]
            }
        }
    }
    
    func placeFurniture(type: String) {
        guard let scene = roomScene else { return }
        
        let furnitureNode = createFurnitureNode(type: type)
        scene.rootNode.addChildNode(furnitureNode)
    }
    
    func createFurnitureNode(type: String) -> SCNNode {
        let furnitureNode = SCNNode()
        
        switch type {
        case "Sofa":
            let sofaGeometry = SCNBox(width: 2.0, height: 0.8, length: 0.9, chamferRadius: 0.1)
            let sofaMaterial = SCNMaterial()
            sofaMaterial.diffuse.contents = UIColor.blue
            furnitureNode.geometry = sofaGeometry
            furnitureNode.geometry?.materials = [sofaMaterial]
            furnitureNode.position = SCNVector3(0, 0.4, 0)
            
        case "Chair":
            let chairGeometry = SCNBox(width: 0.5, height: 0.8, length: 0.5, chamferRadius: 0.05)
            let chairMaterial = SCNMaterial()
            chairMaterial.diffuse.contents = UIColor.red
            furnitureNode.geometry = chairGeometry
            furnitureNode.geometry?.materials = [chairMaterial]
            furnitureNode.position = SCNVector3(1, 0.4, 1)
            
        case "Table":
            let tableGeometry = SCNBox(width: 1.5, height: 0.5, length: 1.0, chamferRadius: 0.05)
            let tableMaterial = SCNMaterial()
            tableMaterial.diffuse.contents = UIColor.brown
            furnitureNode.geometry = tableGeometry
            furnitureNode.geometry?.materials = [tableMaterial]
            furnitureNode.position = SCNVector3(-1, 0.25, -1)
            
        case "Bed":
            let bedGeometry = SCNBox(width: 2.0, height: 0.5, length: 1.5, chamferRadius: 0.1)
            let bedMaterial = SCNMaterial()
            bedMaterial.diffuse.contents = UIColor.gray
            furnitureNode.geometry = bedGeometry
            furnitureNode.geometry?.materials = [bedMaterial]
            furnitureNode.position = SCNVector3(0, 0.25, 2)
            
        default:
            break
        }
        
        return furnitureNode
    }
    
    func generateAILayout() {
        // Placeholder for future AI layout generation
        print("Generating AI Layout")
        // Future implementation will:
        // 1. Analyze room dimensions
        // 2. Suggest optimal furniture placement
        // 3. Automatically add furniture to the scene
    }
    
    func saveRoomDesign() {
        // Placeholder for saving room design
        print("Saving Room Design")
        // Future implementation will:
        // 1. Capture current scene state
        // 2. Save furniture positions
        // 3. Allow user to name and store design
    }
}
