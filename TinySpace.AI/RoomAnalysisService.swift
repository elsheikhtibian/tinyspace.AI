import UIKit
import Vision

class RoomAnalysisService {
    static func analyzeRoom(from image: UIImage, completion: @escaping (CGSize?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let request = VNDetectRectanglesRequest { request, error in
            guard let results = request.results as? [VNRectangleObservation], let rect = results.first else {
                completion(nil)
                return
            }
            
            let roomSize = CGSize(width: rect.boundingBox.width * image.size.width,
                                  height: rect.boundingBox.height * image.size.height)
            completion(roomSize)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Room analysis failed: \(error)")
            completion(nil)
        }
    }
}
