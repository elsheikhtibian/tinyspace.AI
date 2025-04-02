import Vision
import CoreML
import UIKit

class FurnitureDetectionService {
    
    private var model: VNCoreMLModel?
    
    init() {
        do {
            let config = MLModelConfiguration()
            let mlModel = try YOLOv3(configuration: config) // Use the Core ML model file name
            model = try VNCoreMLModel(for: mlModel.model)
        } catch {
            print("Error loading YOLO model: \(error)")
        }
    }
    
    func detectFurniture(in image: UIImage, completion: @escaping ([DetectedFurniture]) -> Void) {
        guard let model = model, let cgImage = image.cgImage else { return }
        
        let request = VNCoreMLRequest(model: model) { request, _ in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            
            let detectedItems = results.map { observation in
                let identifier = observation.labels.first?.identifier ?? "Unknown"
                let boundingBox = observation.boundingBox
                return DetectedFurniture(type: identifier, boundingBox: boundingBox)
            }
            
            DispatchQueue.main.async {
                completion(detectedItems)
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}

struct DetectedFurniture {
    let type: String
    let boundingBox: CGRect
}
