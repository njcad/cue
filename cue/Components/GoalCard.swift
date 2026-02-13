//
//  GoalCard.swift
//  cue
//
//  Created by Nate Cadicamo on 2/6/26.
//

import SwiftUI

struct GoalCard: View {
    // Initialize with Goal data (whoever calls a GoalCard must pass a GoalModel)
    let goal: GoalModel

    // Binding to control action sheet (state lives in parent GoalView)
    @Binding var isShowingActions: Bool

    private let haptic = UIImpactFeedbackGenerator(style: .light)
    
    // Date object -> Month X, YYYY
    private func formatDate(date: Date) -> String {
        return date.formatted(.dateTime
            .day()
            .month(.abbreviated)
            .year()
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Goal created at date
                Text("Goal since \(formatDate(date: goal.createdAt))")
                    .font(.caption)
                    .padding(.bottom, 2)
                    .foregroundStyle(Color.gray)
                
                // Push action menu to right
                Spacer()
                
                // Actions on goal
                Button {
                    haptic.impactOccurred()
                    isShowingActions = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.gray)
                        // Make tappable area bigger than just ellipsis itself
                        .padding(12) // Expand tappable area out
                        .contentShape(Rectangle()) // Make the whole shape a rectangular tap zone
                        .padding(-12) // But––collapse visual area back in so we still get tap zone without seeing it take up space
                }
            }
            
            // The goal itself, big
            Text(goal.content)
                .font(.title)
                .padding(.bottom, 4)
            
            // Streak Badge (could be decomposed, but simple enough to leave here
            if goal.calculateStreak() > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "bolt.shield.fill")
                        .foregroundStyle(Color.white)
                    Text("\(goal.calculateStreak()) day streak")
                        .font(.caption)
                }
                .padding(.vertical, 2)
                .padding(.trailing, 8)
                .padding(.leading, 4)
                .background(Color.brandGreen)
                .clipShape(.capsule) // God this is so handy thanks SwiftUI
            }

            // Spacer is roughly like justify-space-between, fills available space (here, vertically)
            Spacer()
            Text("Your reason")
                .font(.caption)
                .padding(.bottom, 2)
            Text(goal.reason)
                .font(.headline)
        }
        // Note on order: go inside out! Swift returns a NEW View for each modifier
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandGray)
        .cornerRadius(24)
    }
}

#Preview {
    @Previewable @State var showActions = false
    GoalCard(goal: GoalModel(content: "Smile", reason: "Good"), isShowingActions: $showActions)
        .preferredColorScheme(.dark)
        .padding()
}
