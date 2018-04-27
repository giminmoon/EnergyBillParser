//
//  VisionParser.swift
//  GoogleVision Demo
//
//  Created by Gimin Moon on 2/12/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import Foundation
import SwiftyJSON

class VisionParser {
    init() {
    }

    let session = URLSession.shared
    var googleAPIKey = "AIzaSyBZwIBjCbVNquKSWP_Kwzv9rrwN-wMcEUc"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    var outputstring : String = ""
    let distanceFromNumber : Int = 9
    var distanceOfNumber: Int?
    let distanceFromName : Int = 36
    var distanceOfName: Int?
    let distanceOfWhiteSpace = 5

    func analyzeResults(_ dataToParse: Data, completion: @escaping (JSON) -> ()){
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {

            // Use SwiftyJSON to parse results
            let json = try? JSON(data: dataToParse)
            let errorObj: JSON = json!["error"]
  
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                print("Error code \(errorObj["code"]): \(errorObj["message"])")

            } else {
                // Parse the response
//                print(json)
                let responses: JSON = json!["responses"][0]

                // Get text annotations
                let textAnnotations: JSON = responses["textAnnotations"]
                let numLabels: Int = textAnnotations.count
                if numLabels > 0 {
                    let fulltextArray = textAnnotations[0]["description"];
//                    print(fulltextArray)
                    //return string with completion handler
                    completion(fulltextArray)
                } else {
                    completion("")
                }
            }
        })
    }
  
    func createRequest(with imageBase64: String, completion : @escaping (JSON) -> ()){
        // Create our request URL
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")

        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "TEXT_DETECTION"
                    ]
                ]
            ]
        ]

        var jsonObject = Data()
        do{
            jsonObject = try JSONSerialization.data(withJSONObject: jsonRequest, options: [])
        }catch {
            print("Error: cannot create JSON from todo")
            //return output
        }
        request.httpBody = jsonObject as Data

        // Run the request on a background thread
        DispatchQueue.global().async {
            //completion handler
            self.runRequestOnBackgroundThread(request){ output in
                completion(output)
            }}
    }
    func runRequestOnBackgroundThread(_ request: URLRequest, completion: @escaping (JSON) ->()){
        // run the request
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            DispatchQueue.global().async {
                self.analyzeResults(data){ output in
                     completion(output)
                }
            }
        }
        task.resume()
    }
}



