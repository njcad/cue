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
    
    // For animating out the deleted goal
    @State private var isDeleting: Bool = false

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
        withAnimation(.easeOut(duration: 0.3)) {
            isDeleting = true
        }
        // Use a delay to actually delete while the animation takes place
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            service.delete(goal)
        }
    }
    
    func onUndo() {
        service.markIncomplete(goal)
        isShowingActions = false
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
            
            // For deleting
            .opacity(isDeleting ? 0.0 : 1.0)
            .scaleEffect(isDeleting ? 0.0 : 1.0)
            
            // ActionSheet overlay - lives here so it can cover the full screen
            ActionSheet(isShowing: $isShowingActions) {
                VStack(spacing: 8) {
                    ActionSheetButton(label: "Edit goal", icon: "pencil") {
                        onEdit()
                    }
                    
                    ActionSheetButton(label: "Undo completion today", icon: "arrow.uturn.backward", isDisabled: !isCompleted) {
                        onUndo()
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
