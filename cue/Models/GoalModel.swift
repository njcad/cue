//
//  GoalModel.swift
//  cue
//
//  Created by Nate Cadicamo on 2/7/26.
//

import Foundation
import SwiftData

// Here we use some nifty Swift stuff.
// First, the @Model macro generates code at compile time to ensure this class conforms to
// the PersistentModel protocol. The "final" keyword indicates that this class cannot be subclassed.
// Check out Apple Dev docs: https://developer.apple.com/documentation/swiftdata/adding-and-editing-persistent-data-in-your-app
@Model
final class GoalModel {
    var id: UUID
    var content: String
    var reason: String
    var createdAt: Date
    var completedDates: [Date]
    
    // Classes require a manual init function!
    init(content: String, reason: String) {
        self.id = UUID()
        self.content = content
        self.reason = reason
        self.createdAt = Date()
        self.completedDates = []
    }
    
    // Check if a goal is completed today
    func isCompletedToday() -> Bool {
        // Get user device current calendar
        let calendar = Calendar.current
        return completedDates.contains { date in
            calendar.isDateInToday(date)
        }
    }
    
    // Calculate streak: consecutive days completed (including today or starting from yesterday)
    func calculateStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Normalize and dedup completion dates
        let normalizedDates = Set(completedDates.map {
            calendar.startOfDay(for: $0)
        })

        // Determine starting point:
        // If completed today, start from today
        // If not completed today but completed yesterday, start from yesterday
        // Otherwise, no streak
        var currentDate: Date
        if normalizedDates.contains(today) {
            currentDate = today
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                  normalizedDates.contains(yesterday) {
            currentDate = yesterday
        } else {
            return 0
        }

        // Count consecutive days backwards
        var streak = 0
        while normalizedDates.contains(currentDate) {
            streak += 1
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previousDate
        }

        return streak
    }
}
