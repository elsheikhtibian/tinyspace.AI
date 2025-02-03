import Foundation

struct Furniture: Identifiable {
    let id = UUID()
    let name: String
    let type: FurnitureType
    let width: Double
    let height: Double
    let length: Double
    let color: String
}

enum FurnitureType {
    case sofa
    case chair
    case table
    case bed
}
