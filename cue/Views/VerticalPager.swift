//
//  VerticalPager.swift
//  cue
//
//  Created by Nate Cadicamo on 2/6/26.
//

import SwiftUI
import SwiftData

struct VerticalPager: View {
    @Query var goals: [GoalModel]

    // Track which page is currently visible (by index)
    @State private var currentPage: Int?

    private let haptic = UIImpactFeedbackGenerator(style: .soft)

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(goals.enumerated()), id: \.offset) { index, goal in
                        GoalView(goal: goal)
                            .frame(height: geometry.size.height)
                            .id(index)
                    }
                    // Add the start view (add a new goal) at bottom
                    Start()
                        .frame(height: geometry.size.height)
                        .id(goals.count) // Last index
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentPage)
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            
        }
        .ignoresSafeArea()
        .onChange(of: currentPage) { _, _ in
            haptic.impactOccurred()
        }
    }
}
