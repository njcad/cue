//
//  cueApp.swift
//  cue
//
//  Created by Nate Cadicamo on 2/3/26.
//

import SwiftUI
import SwiftData

@main
struct cueApp: App {
    var body: some Scene {
        WindowGroup {
            VerticalPager()
                .preferredColorScheme(.dark)
        }
        // Use SwiftData model container. This creates an SQLite container with GoalModel schema
        .modelContainer(for: GoalModel.self)
//        .modelContainer(for: GoalModel.self) { result in
//            switch result {
//            case .success(let container):
//                seedDemoGoals(into: container)
//            case .failure(let error):
//                print("Encountered error: \(error)")
//            }
//        }
    }
}
//
//// Seed demo goals here
//@MainActor
//func seedDemoGoals(into container: ModelContainer) {
//    let context = container.mainContext
//    
//    // Check if already we have goals
//    let descriptor = FetchDescriptor<GoalModel>()
//    let existingCount = (try? context.fetchCount(descriptor)) ?? 0
//    
//    guard existingCount == 0 else { return }
//    
//    let demoGoals: [GoalModel] = [
//        GoalModel(
//            content: "Stretch for at least 20 minutes a day",
//            reason: "Flexibility is good for the body, mind and soul!",
////            completedDates: [Date.daysAgo(1), Date.daysAgo(2), Date.daysAgo(3), Date.daysAgo(4)]
//        ),
//        GoalModel(
//            content: "Smile at a stranger",
//            reason: "Kindness makes me feel good",
////            completedDates: [Date(), Date.daysAgo(1), Date.daysAgo(2), Date.daysAgo(3), Date.daysAgo(4), Date.daysAgo(5), Date.daysAgo(6)]
//        ),
//        GoalModel(
//            content: "Take the dog on a walk twice a day",
//            reason: "When we both get outside, we both feel better",
////            completedDates: [Date(), Date.daysAgo(2), Date.daysAgo(2), Date.daysAgo(3)]
//        )
//    ]
//    
//    for goal in demoGoals {
//        context.insert(goal)
//    }
//}
                    
   

