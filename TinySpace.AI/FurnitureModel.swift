import SwiftUI
import SceneKit

// Furniture struct with necessary properties
struct Furniture: Codable {
    let id: UUID
    let type: String
    let width: Double
    let height: Double
    let length: Double
    let colorHex: String
    let position: [Float]

    enum CodingKeys: String, CodingKey {
        case id, type, width, height, length, colorHex, position
    }

    // Computed property to convert hex string to SwiftUI Color
    var color: Color {
        Color(hex: colorHex)
    }
}

// Extension to generate a 3D SceneKit node for each piece of furniture
extension Furniture {
    func createNode() -> SCNNode {
        let node = SCNNode()

        // Create a 3D box with furniture dimensions
        let box = SCNBox(width: CGFloat(width), height: CGFloat(height), length: CGFloat(length), chamferRadius: 0.1)

        // Assign material with color
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(Color(hex: colorHex)) // Convert SwiftUI Color to UIColor
        box.materials = [material]

        node.geometry = box
        node.position = SCNVector3(position[0], position[1], position[2])

        return node
    }
}

// Convert SwiftUI Color to UIColor
extension UIColor {
    convenience init(_ color: Color) {
        let uiColor = UIColor(color)
        self.init(cgColor: uiColor.cgColor)
    }
}
