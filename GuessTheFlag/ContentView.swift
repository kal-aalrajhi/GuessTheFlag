//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dr Cpt Blackbeard on 6/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var showingQuestionCount = false
    @State private var questionCounter = 1
    
    @State private var countries = allCountries.shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var selectedFlag = -1 // -1 represents no flag selected
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    // Struct that conforms to the View protocol.
    struct FlagForm: View {
        var country: String
        
        init(_ countries: [String], _ number: Int) {
            self.country = countries[number]
        }
        
        // Computed property named 'body' that is required by the View protocol
        var body: some View {
            Image(country)
                .renderingMode(.original)
                .shadow(radius: 10)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.5, green: 0.1, blue: 0.45), location: 0.3)
            ], center: .bottom, startRadius: 500, endRadius: 740)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .foregroundColor(.black)
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagForm(countries, number)
                        }
                        .rotation3DEffect(
                            .degrees(selectedFlag == number ? 360 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                        .scaleEffect(selectedFlag == correctAnswer && selectedFlag == number ? 1.5 : 1)
                        .animation(.default, value: selectedFlag)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.monospaced())
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over", isPresented: $showingQuestionCount) {
            Button("New Game", action: resetGame)
        } message: {
            Text("Your score is \(score) out of 8")
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])."
            if score != 0 {
                score -= 1
            }
        }
        
        if questionCounter == 8 {
            showingQuestionCount = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        selectedFlag = -1
    }
    
    func resetGame() {
        score = 0
        questionCounter = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
