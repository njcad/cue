//
//  ContentView.swift
//  cue
//
//  Created by Nate Cadicamo on 2/3/26.
//

import SwiftUI

// A button style, conforms to ButtonStyle protocol
struct GreenButton: ButtonStyle {
    /*
     What is "some" keyword?
     An opaque type. Tells Swift compiler this object is renderable,
     as a modified View, which conforms to the View protocol but is
     technically some more complicated object that Swift can infer.
     */
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        /*
         What are all these .thing()s?
         These are chained modifiers, which are methods on the View object.
         They are immutable: each modifier returns a new View.
         Order matters! (unlike react native styles)
         */
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding() // default = 16
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(20)
    }
}

// Content view inherits View protocol
struct ContentView: View {
    // State makes count a value that lives outside the struct, thus mutatable
    @State private var count: Int = 0
    
    func incrementCount() {
        count += 1
    }
    func decrementCount() {
        count -= 1
    }
    
    let goal: GoalModel = GoalModel(
        content: "Pet a dog",
        reason: "They are fluffy"
    )
    
    
    
    var body: some View {
        VStack {
//            Text("Welcome to Cue")
//            Text("Count = \(count)")
//            Buttons(count: $count).padding(.horizontal, 10)
            
//            GoalCard(goal: goal)
            
            SliderButton(title: "Increment", onComplete: incrementCount)
            
        }
        .padding()
    }
}

// Buttons
struct Buttons: View {
    // Bind the count value to parent component
    @Binding var count: Int
    var body: some View {
        HStack {
            Button("+", action: {count += 1})
            
            // Trailing closure syntax
            Button("-") { count -= 1 }
        }
        .buttonStyle(GreenButton())
    }
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
