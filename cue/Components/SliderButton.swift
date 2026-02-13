//
//  SliderButton.swift
//  cue
//
//  Created by Nate Cadicamo on 2/5/26.
//  Haptic, slider button that has draggable component to perform action.
//  Takes inspiration from: https://dribbble.com/shots/20924910-Make-it-Pop-Slider-Button
//

import SwiftUI

struct SliderButton: View {
    // Set struct variable initializer conformation requirements for this custom button when used elsewhere
    let title: String
    let onComplete: () -> Void
    
    // Data to track: current offset of the draggable, isDragging state
    @State private var currentOffset: CGFloat = 0  // CGFloat = Core Graphics Float, dynamically compiles to 32 or 64 bit depending on device
    @State private var isDragging: Bool = false
    
    // Track rotation state of chevron -> check
    @State private var rotationAngle = Angle(degrees: 0)
    
    // Track progress and max drag
    @State private var dragProgress: CGFloat = 0
    
    // Define completion threshold
    private let completionThreshold: CGFloat = 0.8
    
    // Icon morph from chevron right to check mark
    private let morphThreshold: CGFloat = 0.7
    
    // Define preferred haptic effect (arbitrary choices here)
    private let hapticStart = UIImpactFeedbackGenerator(style: .light)
    private let hapticFinish = UINotificationFeedbackGenerator() // use .success later
    @State private var hasTriggeredHapticStart: Bool = false
    
    // Define slider size and view size
    private let sliderSize: CGFloat = 60
    private let buttonHeight: CGFloat = 60
    
    // Note: in swift views, you should put body first and define subviews below it
    var body: some View {
        // GeomtryReader conforms to View protocol; defines its content as a fn of its own size and coordinate space
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Capsule().fill(Color.brandGreen)
                
                // Button title
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .opacity(isDragging ? 0.6 : 1.0)
                
                // Draggable icon with drag gesture, passing in max drag size
                SliderIcon.gesture(dragGesture(maxDrag: geometry.size.width - sliderSize))
            }
            // Set the whole ZStack to set buttonHeight
            .frame(height: buttonHeight)
        }
        // And likewise, set the geometry reader View to buttonHeight
        .frame(height: buttonHeight)
        
        // Prepare the haptics: this reduces latency by priming the "Taptic Engine" apparently
        .onAppear {
            hapticStart.prepare()
            hapticFinish.prepare()
        }
    }
    
    // Define the Draggable icon itself
    private var SliderIcon: some View {
        ZStack {
            Circle().fill(Color.white)
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.brandGreen)
                .font(.title3)
                .bold()
                .rotationEffect(rotationAngle)
                .opacity(computeOpacity(entity: "chevron.right"))
                .scaleEffect(computeScaleEffect(entity: "chevron.right"))
                                   
            Image(systemName: "checkmark")
                .foregroundStyle(Color.brandGreen)
                .font(.title3)
                .bold()
                .opacity(computeOpacity(entity: "checkmark"))
                .scaleEffect(computeScaleEffect(entity: "checkmark"))
        }
        .padding(6)
        .frame(width: sliderSize, height: sliderSize)
        .offset(x: currentOffset)
    }
    
    // Determine opacity given entity is either chevron.right or checkmark
    private func computeOpacity(entity: String) -> CGFloat {
        switch entity {
        case "chevron.right":
            return dragProgress < morphThreshold ? 1 : max(0, 1 - (dragProgress - morphThreshold) / 0.1 )
        default: // implicitly checkmark
            return dragProgress < morphThreshold ? 0 : min(1, (dragProgress - morphThreshold) / 0.1 )
        }
    }
    
    // Determine scale effect similarly
    private func computeScaleEffect(entity: String) -> CGFloat {
        switch entity {
        case "chevron.right":
            return dragProgress < morphThreshold ? 1 : max(0.7, 1 - (dragProgress - morphThreshold) / 0.1 * 0.3 )
            
        default: // implicitly checkmark
            return dragProgress < morphThreshold ? 0.7 : min(1, 0.7 + (dragProgress - morphThreshold) / 0.1 * 0.3 )
        }
    }
    
    // Define the gesture 
    private func dragGesture(maxDrag: CGFloat) -> some Gesture {
        // DragGesture requires onChanged and onEnded
        DragGesture()
            .onChanged { value in // current value of drag
                // Dragging is occuring on change; update dragging
                isDragging = true
                
                // Haptic on start
                if !hasTriggeredHapticStart {
                    hapticStart.impactOccurred()
                    hasTriggeredHapticStart = true
                    hapticFinish.prepare()
                }
                
                // Calculate new offset
                let newOffset = min(max(0, value.translation.width), maxDrag)
                
                // Haptic on finish: we have reached completion threshold
                if currentOffset < maxDrag * completionThreshold &&
                    newOffset >= maxDrag * completionThreshold {
                    hapticFinish.notificationOccurred(.success)
                }
                
                // Update offset
                currentOffset = newOffset
                
                // Update rotation angle
                withAnimation(.linear(duration: 0.05)) {
                    dragProgress = newOffset / maxDrag
                    let newRotationAngle = dragProgress * 90.0
                    rotationAngle = Angle(degrees: newRotationAngle)
                }
                
            }
            .onEnded { value in
                // Dragging ended
                isDragging = false
                hasTriggeredHapticStart = false
                
                // On success
                if currentOffset >= maxDrag * completionThreshold {
                    // Use animation to spring the draggable to completion
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        currentOffset = maxDrag
                        dragProgress = 1
                    }
                    
                    // Completed: pass up to parent
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onComplete()
                    }
                }
                // On not successful
                else {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        currentOffset = 0
                        rotationAngle = Angle(degrees: 0)
                        dragProgress = 0
                    }
                }
            }
    }
}

#Preview {
    SliderButton(title: "test") { print("completed") }
}
