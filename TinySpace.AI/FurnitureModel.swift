import Foundation

struct Furniture: Codable {
    let id: UUID
    let type: String
    let position: (x: Float, y: Float, z: Float)

    enum CodingKeys: String, CodingKey {
        case id, type, position
    }

    // Encoding to handle tuple
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode([position.x, position.y, position.z], forKey: .position)
    }

    // Decoding to handle tuple
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        let positionArray = try container.decode([Float].self, forKey: .position)
        position = (positionArray[0], positionArray[1], positionArray[2])
    }
}

struct FurnitureCatalog {
    static let allFurniture: [Furniture] = [
        Furniture(name: "Sofa", width: 2.0, height: 0.8, length: 0.9, color: .blue),
        Furniture(name: "Chair", width: 0.5, height: 0.8, length: 0.5, color: .red),
        Furniture(name: "Table", width: 1.5, height: 0.5, length: 1.0, color: .brown),
        Furniture(name: "Bed", width: 2.0, height: 0.5, length: 1.5, color: .gray)
    ]
}
