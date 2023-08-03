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
                print(observation)
                return observation.topCandidates(1).first?.string
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
            completion(parseResults(for: recognizedText.map({ cleanText(originalText: $0)})))
        } catch {
            print(error)
        }
    }
    
    private func getCardDict(stringRange: String) -> [String] {
        let cardNums = stringRange.components(separatedBy: "-")
        var finalCardNums = [String]()
        if cardNums.count > 1 {
            var cardCount = Int(cardNums[0])!
            finalCardNums.append(String(cardCount))
            repeat {
                cardCount += 1
                finalCardNums.append(String(cardCount))
            } while cardCount < Int(cardNums[1])!
        }
        else {
            finalCardNums.append(cardNums[0])
        }
        
        return finalCardNums
    }
    
    
    
    func parseResults(for recognizedText: [String]) -> CardDetails {
        print(recognizedText)
        
        var data = getCardNumber(recognizedText: recognizedText)
        print("======================================================")
        print(data)
        print("======================================================")
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
    private func cleanText(originalText: String) -> String {
            var replaced = originalText.replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ".", with: "")
            replaced = String(replaced.filter { !"\n\t\r".contains($0) })
            return replaced.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    
    func getCardNumber( recognizedText: [String]) -> String {
        var text = recognizedText
        text.removeAll(where: {
            if(Int($0) == nil){
            return true
        } else {
            return false
        }})

        var ccNumber = ""
        var remaingNums = 16
        var fullNum = text.first(where: { $0.count >= 14 })
        
        // If we get detected full number directly return it directly
        if(fullNum != nil && fullNum!.count >= 14) {
            ccNumber = fullNum!
            remaingNums = 0
            print("first case")
            return ccNumber
        }
        var maxInteraction = 10
        while (remaingNums > 0 && maxInteraction > 0) {
            print(maxInteraction)
            var index = text.firstIndex(where: { $0.count > 0 })
            if(index != nil){
                ccNumber = ccNumber + text[index!]
                remaingNums -= text[index!].count
            }
            maxInteraction -= 1
        }
        
        return ccNumber
    }
    
    
}
