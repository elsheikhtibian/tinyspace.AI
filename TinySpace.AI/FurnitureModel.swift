import SwiftUI
import SceneKit

// MARK: - Furniture Model
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

    // Computed property to get SwiftUI Color
    var color: Color {
        Color(hex: colorHex) // ✅ Uses the fixed hex initializer
    }

    // Encode properties correctly
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(length, forKey: .length)
        try container.encode(colorHex, forKey: .colorHex)
        try container.encode(position, forKey: .position)
    }

    // Decode properties correctly
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        width = try container.decode(Double.self, forKey: .width)
        height = try container.decode(Double.self, forKey: .height)
        length = try container.decode(Double.self, forKey: .length)
        colorHex = try container.decode(String.self, forKey: .colorHex)
        position = try container.decode([Float].self, forKey: .position)
    }
}

// MARK: - 3D Node Creation for SceneKit
extension Furniture {
    func createNode() -> SCNNode {
        let node = SCNNode()

        // Create a 3D box with furniture dimensions
        let box = SCNBox(width: CGFloat(width), height: CGFloat(height), length: CGFloat(length), chamferRadius: 0.1)

        // Assign material with color
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(hex: colorHex) // ✅ Fix: Convert hex string to UIColor properly
        box.materials = [material]

        node.geometry = box
        node.position = SCNVector3(position[0], position[1], position[2])

        return node
    }
}

// MARK: - Convert Hex String to SwiftUI Color
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        let scanner = Scanner(string: hexSanitized)
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        if hexSanitized.count == 6 {
            self.init(red: red, green: green, blue: blue)
        } else {
            self.init(white: 0.5) // ✅ Default to gray if hex is invalid
        }
    }
}

// MARK: - Convert Hex String to UIColor for SceneKit
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// MARK: - Furniture Catalog
struct FurnitureCatalog {
    static let allFurniture: [Furniture] = [
        Furniture(id: UUID(), type: "Sofa", width: 2.0, height: 0.8, length: 0.9, colorHex: "#0000FF", position: [0, 0, 0]),
        Furniture(id: UUID(), type: "Chair", width: 0.5, height: 0.8, length: 0.5, colorHex: "#FF0000", position: [0, 0, 0]),
        Furniture(id: UUID(), type: "Table", width: 1.5, height: 0.5, length: 1.0, colorHex: "#A52A2A", position: [0, 0, 0]),
        Furniture(id: UUID(), type: "Bed", width: 2.0, height: 0.5, length: 1.5, colorHex: "#808080", position: [0, 0, 0])
    ]
}
