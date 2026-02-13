//
//  ActionSheet.swift
//  cue
//
//  Created by Nate Cadicamo on 2/10/26.
//

import SwiftUI

// This <> syntax allows us to pass any View as Content parameter
// We call it from GoalView and pass in a VStack of ActionSheetButtons
struct ActionSheet<Content: View>: View {
    // Track state of sheet's presentation binded with caller (GoalView)
    @Binding var isShowing: Bool
    
    // Receive content to display. ViewBuilder allows us to receive a view as a param
    @ViewBuilder let content: () -> Content
    
    // Track the dragOffset of the sheet
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Backdrop: dim the background of the app
            if isShowing {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() } // To close the sheet
                    .transition(.opacity)
            }

            // Sheet itself (defined below)
            if isShowing {
                sheet
                    .transition(.move(edge: .bottom))
                    .offset(y: dragOffset)
                    .gesture(dragGesture) // Defined below
            }
        }
        // Again, inside out. Give it full screen size
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        
        // Animate in and animate drag behavior with spring
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isShowing)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: dragOffset)
    }
    
    // Sheet content
    private var sheet: some View {
        VStack(spacing: 0) {
            // Drag handle
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 36, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 20)

            // The actions
            content()
                .padding(.horizontal, 20)
                .padding(.bottom, 34) // A little hacky. Probably a safer way to manage this with the bottom of screen
        }
        .frame(maxWidth: .infinity)
        .background(
            // Solid background that extends to bottom edge, behind the rounded corners
            Color.brandGray
                .ignoresSafeArea(edges: .bottom)
        )
        .clipShape(
            // Only round the top corners. Just a RoundedRectangle but you can set the radii differently
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 24
            )
        )
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // Only allow dragging down (positive values)
                // Future improvement: allow dragging up with more actions, like Spotify
                if value.translation.height > 0 {
                    dragOffset = value.translation.height
                }
            }
            .onEnded { value in
                // Dismiss if dragged far enough or fast enough
                if value.translation.height > 100 || value.velocity.height > 500 {
                    dismiss()
                } else {
                    dragOffset = 0 // Always reset to initial point
                }
            }
    }
    
    // To dismiss
    private func dismiss() {
        dragOffset = 0
        isShowing = false
    }
}
