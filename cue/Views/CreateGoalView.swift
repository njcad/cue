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
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var content: String = ""
    @State private var reason: String = ""
    
    // Use the SwiftData context
    @Environment(\.modelContext) private var context
    
    // Use the service we made
    private var service: GoalService {
        // Pass the context
        GoalService(context: context)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("What's your goal?") {
                    TextField("I want to...", text: $content) // Bind content
                }
                Section("Why does it matter?") {
                    TextField("Because...", text: $reason)
                }
            }
            .navigationTitle(goalToEdit != nil ? "Edit goal" : "New goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        _ = service.create(content: content, reason: reason)
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
        }
    }
}
