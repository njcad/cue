//
//  GoalView.swift
//  cue
//
//  Created by Nate Cadicamo on 2/6/26.
//

import SwiftUI
import SwiftData

struct GoalView: View {
    // Initializer requirement: pass a goal
    let goal: GoalModel

    // Use the SwiftData context
    @Environment(\.modelContext) private var context

    // Use the service we made
    private var service: GoalService {
        GoalService(context: context)
    }

    // Action sheet and edit sheet state (owned here, passed to GoalCard)
    @State private var isShowingActions: Bool = false
    @State private var isShowingEditSheet: Bool = false
    
    // For delete confirmation
    @State private var isShowingDeleteConfirmation: Bool = false

    private var isCompleted: Bool {
        goal.isCompletedToday()
    }

    func onComplete() {
        service.markComplete(goal)
    }

    func onEdit() {
        isShowingActions = false
        isShowingEditSheet = true
    }

    func onAttemptDelete() {
        isShowingActions = false
        isShowingDeleteConfirmation = true
    }
    
    func onConfirmDelete() {
        service.delete(goal)
    }
    
    var body: some View {
        ZStack {
            VStack {
                GoalCard(goal: goal, isShowingActions: $isShowingActions)
                if !isCompleted {
                    SliderButton(title: "Mark as Done", onComplete: onComplete)
                        .transition(
                            .move(edge: .bottom)
                            .combined(with: .opacity)
                        )
                }
                else {
                    Completed()
                        .transition(
                            .move(edge: .bottom)
                            .combined(with: .scale)
                            .combined(with: .opacity)
                        )
                }
            }
            .padding(.top, 48)
            .padding(.bottom, 24)
            .padding()
            
            // ActionSheet overlay - lives here so it can cover the full screen
            ActionSheet(isShowing: $isShowingActions) {
                VStack(spacing: 8) {
                    ActionSheetButton(label: "Edit goal", icon: "pencil") {
                        onEdit()
                    }
                    ActionSheetButton(label: "Delete goal", icon: "trash", isDestructive: true) {
                        onAttemptDelete()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(
            .spring(response: 0.4, dampingFraction: 0.7),
            value: isCompleted
        )
        
        // Edit sheet
        .sheet(isPresented: $isShowingEditSheet) {
            CreateGoalView(goalToEdit: goal)
        }
        
        // Alert dialog for delete confirmation
        .alert("Delete this goal?", isPresented: $isShowingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { isShowingDeleteConfirmation = false }
            Button("Delete", role: .destructive) { onConfirmDelete()}
        }
        
    }
}
