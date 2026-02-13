//
//  CreateGoalView.swift
//  cue
//
//  Created by Nate Cadicamo on 2/7/26.
//

import SwiftUI

struct CreateGoalView: View {
    // Optionally accept an existing goal to EDIT rather than create
    var goalToEdit: GoalModel?
    
    // Access dismiss var from environment. SwiftUI automatically provides a dismiss for any presented view
    @Environment(\.dismiss) private var dismiss
    
    @State private var content: String = ""
    @State private var reason: String = ""

    // To focus entry
    @FocusState private var isContentFocused: Bool

    // Grab the model context from cueApp main
    @Environment(\.modelContext) private var context

    private func getService() -> GoalService {
        GoalService(context: context)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("What's your goal?") {
                    TextField("I want to...", text: $content)
                        .focused($isContentFocused)
                }
                Section("Why does it matter?") {
                    TextField("Because...", text: $reason)
                }
            }
            // Conditionally render the title
            .navigationTitle(goalToEdit != nil ? "Edit goal" : "New goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let goal = goalToEdit {
                            getService().edit(goal, content: content, reason: reason)
                        } else {
                            _ = getService().create(content: content, reason: reason)
                        }
                        dismiss()
                    }
                    .disabled(content.isEmpty || reason.isEmpty)
                }
            }
        }
        .onAppear {
            if let goal = goalToEdit {
                content = goal.content
                reason = goal.reason
            }
            // Auto-focus content field
            isContentFocused = true
        }
    }
}
