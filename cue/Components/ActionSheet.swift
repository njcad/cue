//
//  ActionSheet.swift
//  cue
//
//  Created by Nate Cadicamo on 2/10/26.
//

import SwiftUI

// This <> syntax allows us to pass any View as Content parameter
struct ActionSheet<Content: View>: View {
    // Track state of sheet's presentation binded with caller
    @Binding var isShowing: Bool
    
    // Receive content to display
    @ViewBuilder let content: () -> Content
    
    //
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Backdrop
            if isShowing {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)
            }

            // Sheet itself
            if isShowing {
                sheet
                    .transition(.move(edge: .bottom))
                    .offset(y: dragOffset)
                    .gesture(dragGesture)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isShowing)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: dragOffset)
        .onChange(of: isShowing) { _, newValue in
            if newValue {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        }
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
                .padding(.bottom, 34)
        }
        .frame(maxWidth: .infinity)
        .background(
            // Solid background that extends to bottom edge, behind the rounded corners
            Color.brandGray
                .ignoresSafeArea(edges: .bottom)
        )
        .clipShape(
            // Only round the top corners
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
                if value.translation.height > 0 {
                    dragOffset = value.translation.height
                }
            }
            .onEnded { value in
                // Dismiss if dragged far enough or fast enough
                if value.translation.height > 100 || value.velocity.height > 500 {
                    dismiss()
                } else {
                    dragOffset = 0
                }
            }
    }
    
    // To dismiss
    private func dismiss() {
        dragOffset = 0
        isShowing = false
    }
}
