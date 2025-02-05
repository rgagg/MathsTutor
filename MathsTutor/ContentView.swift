//
//  ContentView.swift
//  MathsTutor
//
//  Created by Richard Gagg on 5/2/2025.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
  
  @State private var firstNumber: Int = 0
  @State private var secondNumber: Int = 0
  @State private var firstNumberEmoji: String = ""
  @State private var secondNumberEmoji: String = ""
  @State private var answer: String = ""
  @State private var soundName: String = ""
  @State private var audioPlayer: AVAudioPlayer!
  @State private var messageText: String = ""
  @State private var answerButtonIsDisabled: Bool = false
  @State private var textFieldIsDisabled: Bool = false
  @State private var playAgainButtonIsHidden: Bool = false
  
  @FocusState private var textFieldIsFocused: Bool
  
  private let emojis: [String] = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
  
  var body: some View {
    VStack {
      
      Group {
        Text(firstNumberEmoji)
        Text("+")
        Text(secondNumberEmoji)
      }
      .font(.system(size: 80))
      .minimumScaleFactor(0.5)
      .multilineTextAlignment(.center)
      .lineLimit(2)
      
      Spacer()
      
      HStack {
        Text("\(firstNumber)")
        Text("+")
        Text("\(secondNumber)")
        Text("=")
        
        TextField("", text: $answer)
          .textFieldStyle(.roundedBorder)
          .multilineTextAlignment(.center)
          .frame(width: 60)
          .overlay {
            RoundedRectangle(cornerRadius: 12)
              .stroke(.green, lineWidth: 3)
          }
          .keyboardType(.numberPad)
      }
      .font(.largeTitle)
      .focused($textFieldIsFocused)
      .disabled(textFieldIsDisabled)
        
        Button {
          getAnswer()
        } label: {
          Text("Answer")
        }
        .buttonStyle(.borderedProminent)
        .font(.title)
        .tint(.green)
        .disabled(answer.isEmpty || !answerButtonIsDisabled)
      
      Spacer()
      
      Text(messageText)
        .font(.largeTitle)
        .foregroundStyle(messageText == "Correct!" ? .green : .red)
        .multilineTextAlignment(.center)
      
      if !playAgainButtonIsHidden {
        Button {
          getEquation()
        } label: {
          Text("Next Question")
        }
        .buttonStyle(.automatic)
        .font(.title)
        .tint(.blue)
      }
      
    }
    .padding()
    .onAppear() {
      getEquation()
    }
  }
  
  func getAnswer() {
    textFieldIsFocused = false
    
    playAgainButtonIsHidden = false
    answerButtonIsDisabled = false
    textFieldIsDisabled = true
    
    if (Int(answer) == firstNumber + secondNumber) {
      playSound(soundName: "correct")
      messageText = "Correct!"
    } else {
      playSound(soundName: "wrong")
      messageText = "Sorry. The correct answer is \(firstNumber + secondNumber)"
    }
  }
  
  func getEquation() {
    playAgainButtonIsHidden = true
    answerButtonIsDisabled = true
    textFieldIsDisabled = false
    
    messageText = ""
    
    firstNumber = Int.random(in: 1...10)
    secondNumber = Int.random(in: 1...10)
    
    firstNumberEmoji = (String(repeating: emojis.randomElement()!, count: firstNumber))
    secondNumberEmoji = (String(repeating: emojis.randomElement()!, count: secondNumber))
    
    answer = ""
  }
  
  func playSound(soundName: String) {
    
    guard let soundFile = NSDataAsset(name: soundName) else {
      print("🤬 Could not find file named \(soundName).")
      return
    }
    
    do {
      audioPlayer = try AVAudioPlayer(data: soundFile.data)
      audioPlayer.play()
    } catch {
      print("🤬 ERROR: \(error.localizedDescription) creating audioPlayer.")
    }
  }
  
}

#Preview {
  ContentView()
}
