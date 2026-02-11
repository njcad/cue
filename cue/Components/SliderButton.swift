//
//  SliderButton.swift
//  cue
//
//  Created by Nate Cadicamo on 2/5/26.
//  Haptic, slider button that has draggable component to perform action
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
    
    // Track progress
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
    
    var body: some View {
        // GeomtryReader conforms to View protocol; defines its content as a fn of its own size and coordinate space
        GeometryReader { geometry in
            // Define the max width that we can drag here (used below in DragGesture)
            let maxDrag = geometry.size.width - sliderSize
            
            ZStack(alignment: .leading) {
                // Background
                Capsule().fill(Color.brandGreen)
                
                // Button title
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .opacity(isDragging ? 0.6 : 1.0)
                
                // Draggable
                ZStack {
                    Circle().fill(Color.white)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.brandGreen)
                        .font(.title3)
                        .bold()
                        .rotationEffect(rotationAngle)
                        .opacity(dragProgress < morphThreshold ? 1 : max(0, 1 - (dragProgress - morphThreshold) / 0.1 ))
                        .scaleEffect(dragProgress < morphThreshold ? 1 : max(0.7, 1 - (dragProgress - morphThreshold) / 0.1 * 0.3 ))
                                           
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.brandGreen)
                        .font(.title3)
                        .bold()
                        .opacity(dragProgress < morphThreshold ? 0 : min(1, (dragProgress - morphThreshold) / 0.1 ))
                        .scaleEffect(dragProgress < morphThreshold ? 0.7 : min(1, 0.7 + (dragProgress - morphThreshold) / 0.1 * 0.3 ))
                }
                .padding(6)

                .frame(width: sliderSize, height: sliderSize)
                .offset(x: currentOffset)
                
                .gesture(
                    // DragGesture requires onChanged and onEnded
                    DragGesture()
                        .onChanged { value in
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
                
                )
            }
            // Set the whole ZStack to set buttonHeight
            .frame(height: buttonHeight)
        }
        // And likewise, set the geometry reader View to buttonHeight
        .frame(height: buttonHeight)
        
        // Prepare the haptics: this reduces latency by priming the "Taptic Engine"
        .onAppear {
            hapticStart.prepare()
            hapticFinish.prepare()
        }
    }
}

#Preview {
    SliderButton(title: "test") { print("completed") }
}
