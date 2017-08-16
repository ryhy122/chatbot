//
//  GoogleVisionAPI.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/21.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit


class GoogleVisionAPI {
    
    var googleAPIKey = "AIzaSyCFj5-Ha-s5fHqLozqffHAJvR7JwFW5AGk"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    let imagePicker = UIImagePickerController()
    let session = URLSession.shared
    
    class func analyzeResults(_ dataToParse: Data, completionHandler: @escaping ((String, String) -> Void)) {
        
        var tempEmotion = ""
        var tempLabel = ""
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            if (errorObj.dictionaryValue != [:]) {
//                self.labelResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
            } else {
                print(json)
                let responses: JSON = json["responses"][0]
                let faceAnnotations: JSON = responses["faceAnnotations"]
                let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
                let numPeopleDetected:Int = faceAnnotations.count
                
                var emotionTotals: [String: Double] = [
                    "sorrow": 0, "joy": 0,
                    "surprise": 0, "anger": 0
                ]
                var emotionLikelihoods: [String: Double] = [
                    "VERY_LIKELY": 0.9,
                    "LIKELY": 0.75,
                    "POSSIBLE": 0.5,
                    "UNLIKELY":0.25,
                    "VERY_UNLIKELY": 0.0]
                
                for index in 0..<numPeopleDetected {
                    let personData:JSON = faceAnnotations[index]
                    for emotion in emotions {
                        let lookup = emotion + "Likelihood"
                        let result:String = personData[lookup].stringValue
                        emotionTotals[emotion]! += emotionLikelihoods[result]!
                    }
                }
                
                // Get emotion likelihood as a % and display in UI
                for (emotion, total) in emotionTotals {
                    let likelihood:Double = total / Double(numPeopleDetected)
                    let percent: Double = Double(round(likelihood * 100))
                    tempEmotion += "\(emotion): \(percent)%\n"
                    
                }
                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    var labelResultsText:String = "What I can see in this picture is  "
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)"
                        }
                    }
                    tempLabel = labelResultsText
                } else {
                }
                
                completionHandler(tempEmotion, tempLabel)
            }
        })
        
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func createRequest(with imageBase64: String, completion: @escaping ((String, String) -> Void)) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 20
                    ],
                    [
                        "type": "FACE_DETECTION",
                        "maxResults": 20
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        guard let data = try? jsonObject.rawData() else {
            return
        }
        request.httpBody = data
        DispatchQueue.global().async {
            self.runRequestOnBackgroundThread(request, completion: { (label, face) in
                completion(label, face)
            })
        }
    }
    
    func runRequestOnBackgroundThread(_ request: URLRequest, completion: @escaping ((String, String) -> Void)) {
        let task: URLSessionDataTask = session.dataTask(with: request) {
            (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            GoogleVisionAPI.analyzeResults(data, completionHandler: { (data, face) in
                completion(data, face)
            })
        }
        task.resume()
    }
    
    

}


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
