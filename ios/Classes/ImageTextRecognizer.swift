import Foundation
import Vision
import VisionKit

@available(iOS 13.0, *)
public protocol ImageTextRecognizable: VNDocumentCameraViewControllerDelegate { }

@available(iOS 13.0, *)
public extension ImageTextRecognizable {
    
    func validateImage(image: UIImage?, completion: @escaping (CardDetails?) -> Void) {
        guard let cgImage = image?.cgImage else { return completion(nil) }
        
        var recognizedText = [String]()
        
        var textRecognitionRequest = VNRecognizeTextRequest()
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = ["Expiry Date"]
        textRecognitionRequest = VNRecognizeTextRequest() { (request, error) in
            guard let results = request.results,
                  !results.isEmpty,
                  let requestResults = request.results as? [VNRecognizedTextObservation]
            else { return completion(nil) }
            recognizedText = requestResults.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
            completion(parseResults(for: recognizedText))
        } catch {
            print(error)
        }
    }
    
    func parseResults(for recognizedText: [String]) -> CardDetails {
        print(recognizedText)
        // Credit Card Number
        let creditCardNumber = recognizedText.first(where: { $0.count >= 14 && ["1","2" ,"4", "5", "3", "6", "7", "8", "9", "0" ].contains($0.first) })
        
        // Expiry Date
        let expiryDateString = recognizedText.first(where: { $0.count > 4 && $0.contains("/") })
        let expiryDate = expiryDateString?.filter({ $0.isNumber || $0 == "/" })
        
        let wordsToAvoid = [creditCardNumber, expiryDateString] +
        Constants.blackListedWords
        
        // name
        let name = recognizedText.filter({ !wordsToAvoid.contains($0.lowercased()) }).last
        
        return CardDetails(numberWithDelimiters: creditCardNumber, name: name, expiryDate: expiryDate)
    }
}
