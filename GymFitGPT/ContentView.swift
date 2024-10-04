//
//  ContentView.swift
//  GymFitGPT
//
//  Created by Arvind Kutirakulam on 5/29/24.
//

import SwiftUI
//import ChatGPTSwift




struct UserData {
    var weight: String = ""
    var height: String = ""
    var fitnessGoal: String = ""
    var gymFrequency: String = ""
    var fitnessLevel: String = ""
    var workoutType: String = ""
    var dietaryRestrictions: String = ""
    var sessionLength: String = ""
}

struct ContentView: View {
    // State variable to hold user input
    @State private var userData = UserData()
    @State private var workoutPlan: String = ""
    @State private var showWorkoutPlan = false
    
    private let gptService = GPTService()
    
    var body: some View {
        NavigationView {
            Form {
                // Basic user data
                Section(header: Text("Your Details")) {
                    TextField("Weight (kg)", text: $userData.weight)
                    TextField("Height (cm)", text: $userData.height)
                    TextField("Your Fitness Goal", text: $userData.fitnessGoal)
                    TextField("How often do you go to the gym?", text: $userData.gymFrequency)
                }
                
                // Additional questions for more personalized results
                Section(header: Text("Additional Information")) {
                    TextField("Fitness Level (Beginner, Intermediate, Advanced)", text: $userData.fitnessLevel)
                    TextField("Preferred Workout Type (Cardio, Strength, etc.)", text: $userData.workoutType)
                    TextField("Dietary Restrictions (if any)", text: $userData.dietaryRestrictions)
                    TextField("Preferred Session Length (in minutes)", text: $userData.sessionLength)
                }
                
                // Button to generate workout plan using GPT
                Button(action: {
                    fetchWorkoutPlan()
                }) {
                    Text("Generate Workout Plan")
                }
                
                // Show the generated workout plan
                if showWorkoutPlan {
                    Section(header: Text("Your Workout Plan")) {
                        Text(workoutPlan)
                    }
                }
            }
            .navigationTitle("GymFitGPT")
        }
    }
    
    // Function to send user data to GPT and get a response
    func fetchWorkoutPlan() {
        let input = """
        Weight: \(userData.weight) kg, Height: \(userData.height) cm, Goal: \(userData.fitnessGoal), Frequency: \(userData.gymFrequency),
        Fitness Level: \(userData.fitnessLevel), Workout Type: \(userData.workoutType), Dietary Restrictions: \(userData.dietaryRestrictions), Session Length: \(userData.sessionLength)
        """
        
        // Call GPT API (OpenAI)
        gptService.getGPTResponse(input: input) { response in
            DispatchQueue.main.async {
                workoutPlan = response // Update the workout plan
                showWorkoutPlan = true
            }
        }
    }
    
}
#Preview {
    ContentView()
}

