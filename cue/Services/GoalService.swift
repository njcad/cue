//
//  GoalService.swift
//  cue
//
//  Created by Nate Cadicamo on 2/7/26.
//

import SwiftData
import Foundation

@MainActor
class GoalService {
    // Use the SwiftData model context
    private let context: ModelContext
    
    // Classes need an init; initialize the model context
    init(context: ModelContext) {
        self.context = context
    }
    
    // METHODS
    
    // Create
    func create(content: String, reason: String) -> GoalModel {
        let goal = GoalModel(content: content, reason: reason)
        context.insert(goal)
        return goal
    }
    
    // Delete
    func delete(_ goal: GoalModel) {
        context.delete(goal)
    }
    
    // Mark complete
    func markComplete(_ goal: GoalModel) {
        guard !goal.isCompletedToday() else { return }
        goal.completedDates.append(Date())
    }
    
    // Undo completion
    func markIncomplete(_ goal: GoalModel) {
        let calendar = Calendar.current
        goal.completedDates.removeAll { calendar.isDateInToday($0) }
    }
    
    // Edit
    func edit(_ goal: GoalModel, content: String, reason: String) {
        goal.content = content
        goal.reason = reason
    }
}
