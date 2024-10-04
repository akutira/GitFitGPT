//
//  GPTService.swift
//  GymFitGPT
//
//  Created by Arvind Kutirakulam on 5/30/24.
//

import Foundation

class GPTService {
    // Function to call GPT API
    func getGPTResponse(input: String, completion: @escaping (String) -> Void) {
        // Prepare API request
        let apiKey = ""
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini", // GPT model
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": "Create a personalized workout plan based on the following information: \(input)"]
            ],
            "temperature": 0.7,
            "max_tokens": 256
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion("Error occurred while preparing the request.")
            return
        }
        
        // Make the API call
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                completion("Sorry, something went wrong.")
                return
            }
            
            guard let data else {
                print("No data received")
                completion("Sorry, no data received.")
                return
            }

            do {
                // Try to parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("JSON Response: \(json.debugDescription)") // Print the whole JSON response for debugging

                    // Attempt to extract the text from the choices
                    if let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let text = message["content"] as? String {
                        // Pass the trimmed text to the completion handler
                        completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    } else {
                        // If text is not found, log the full JSON and return an error message
                        print("No text found in choices. Full JSON: \(json.debugDescription)")
                        completion("Unable to generate a workout plan. Please try again.")
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion("Error occurred while processing the response.")
            }
        }
        task.resume()
    }
}
