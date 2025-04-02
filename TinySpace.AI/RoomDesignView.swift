import SwiftUI
import SceneKit


struct RoomDesignView: View {
    let roomImage: UIImage
    let roomDimensions: (width: Double, depth: Double, height: Double)
    @State private var detectedFurniture: [DetectedFurniture] = []
    @State private var roomScene: SCNScene?

    let furnitureDetector = FurnitureDetectionService()
    
    var body: some View {
        VStack {
            Image(uiImage: roomImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(10)
                .padding()
            
            SceneView(scene: roomScene, options: [.allowsCameraControl])
                .frame(height: 300)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
        }
        .onAppear {
            setupRoomScene()
            detectFurniture()
        }
    }
    
    func setupRoomScene() {
        let scene = SCNScene()
        
        // Create room based on dimensions
        let floor = SCNPlane(width: roomDimensions.width, height: roomDimensions.depth)
        let floorNode = SCNNode(geometry: floor)
        floorNode.rotation = SCNVector4(1, 0, 0, -Float.pi/2)
        scene.rootNode.addChildNode(floorNode)
        
        roomScene = scene
    }
    
    func detectFurniture() {
        furnitureDetector.detectFurniture(in: roomImage) { detectedItems in
            detectedFurniture = detectedItems
            placeFurnitureInScene()
        }
    }
    
    func placeFurnitureInScene() {
        guard let scene = roomScene else { return }
        
        for item in detectedFurniture {
            let furnitureNode = createFurnitureNode(for: item)
            scene.rootNode.addChildNode(furnitureNode)
        }
    }
    
    func createFurnitureNode(for item: DetectedFurniture) -> SCNNode {
        let furnitureNode = SCNNode()
        
        switch item.type.lowercased() {
        case "sofa":
            let sofaGeometry = SCNBox(width: 2.0, height: 0.8, length: 0.9, chamferRadius: 0.1)
            furnitureNode.geometry = sofaGeometry
            furnitureNode.position = SCNVector3(0, 0.4, 0)
            
        case "chair":
            let chairGeometry = SCNBox(width: 0.5, height: 0.8, length: 0.5, chamferRadius: 0.05)
            furnitureNode.geometry = chairGeometry
            furnitureNode.position = SCNVector3(1, 0.4, 1)
            
        default:
            return SCNNode()
        }
        
        return furnitureNode
    }
}
