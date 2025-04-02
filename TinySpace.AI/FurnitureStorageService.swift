import Foundation

class FurnitureStorageService {
    private static let key = "SavedRoomDesigns"

    static func saveDesign(furniture: [Furniture]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(furniture) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    static func loadDesign() -> [Furniture] {
        guard let savedData = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Furniture].self, from: savedData) {
            return decoded
        }
        return []
    }
}

