//
//  Goal.swift
//  cue
//
//  Created by Nate Cadicamo on 2/6/26.
//

// Foundation gives fundamental data types
import Foundation

// A Goal will be saved to local storage, so it needs to be identifiable (requires id), and codable (can move in and out of JSON, for example)
struct Goal: Identifiable, Codable, Hashable {
    let id: UUID
    let content: String
    let reason: String
    let createdAt: Date
    var completedDates: [Date]
    
    // Set our own initializer: id, createdAt, completedDates handled automatically, content and reason must be provided
    init(id: UUID = UUID(), content: String, reason: String, createdAt: Date = Date(), completedDates: [Date] = []) {
        self.id = id
        self.content = content
        self.reason = reason
        self.createdAt = createdAt
        self.completedDates = completedDates
    }
    
    // Check if a goal is completed today
    func isCompletedToday() -> Bool {
        // Get user device current calendar
        let calendar = Calendar.current
        return completedDates.contains { date in
            calendar.isDateInToday(date)
        }
    }
    
    // Calculate streak
    func calculateStreak() -> Int {
        // Use the user's current calendar
        let calendar = Calendar.current
        
        // Normalize and dedup
        let normalizedDates = Set(completedDates.map { date in
            calendar.startOfDay(for: date)
        })
        
        // Count the streak
        var streak: Int = 0
        var currentDate = calendar.startOfDay(for: Date())
        while normalizedDates.contains(currentDate) {
            streak += 1
            // calendar.date() returns an optional so we have to guard / else it here
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
            currentDate = previousDate
        }
        return streak
    }
}

// Helper extension to create dates relative to today
extension Date {
    static func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date())!
    }
}

let demoGoals: [Goal] = [
    Goal(
        content: "Stretch for at least 20 minutes a day",
        reason: "Flexibility is good for the body, mind and soul!",
        completedDates: [Date.daysAgo(1), Date.daysAgo(2), Date.daysAgo(3), Date.daysAgo(4)]
    ),
    Goal(
        content: "Smile at a stranger",
        reason: "Kindness makes me feel good",
        completedDates: [Date(), Date.daysAgo(1), Date.daysAgo(2), Date.daysAgo(3), Date.daysAgo(4), Date.daysAgo(5), Date.daysAgo(6)]
    ),
    Goal(
        content: "Take the dog on a walk twice a day",
        reason: "When we both get outside, we both feel better",
        completedDates: [Date(), Date.daysAgo(2), Date.daysAgo(2), Date.daysAgo(3)]
    )
]
