import Foundation
import SceneKit

class AILayoutGenerator {
    static func generateLayout(for roomSize: CGSize, completion: @escaping ([SCNNode]) -> Void) {
        var furnitureNodes: [SCNNode] = []
        
        let catalog = FurnitureCatalog.allFurniture
        for furniture in catalog {
            let node = furniture.createNode()
            
            // Basic AI layout: Place furniture randomly within room bounds
            let xPosition = Float.random(in: -Float(roomSize.width) / 2 ... Float(roomSize.width) / 2)
            let zPosition = Float.random(in: -Float(roomSize.height) / 2 ... Float(roomSize.height) / 2)
            node.position = SCNVector3(xPosition, node.position.y, zPosition)
            
            furnitureNodes.append(node)
        }
        
        completion(furnitureNodes)
    }
}
