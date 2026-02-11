# Data Persistence Implementation Plan

## Current State

Your app has a solid foundation:
- **`Goal` struct** with `id`, `content`, `reason`, `createdAt`, and `completedDates`
- **Already `Codable`** — this means the model can be encoded/decoded (good foresight!)
- **No persistence** — currently loads hardcoded `demoGoals`
- **Empty `ViewModels/` folder** — ready for state management

---

## The Plan: SwiftData

We'll use **SwiftData**, Apple's modern persistence framework (iOS 17+). It's the simplest, most "Swifty" approach and is where Apple is heading.

### Why SwiftData over alternatives?

| Option | Pros | Cons |
|--------|------|------|
| **SwiftData** | Simple, Swift-native, automatic | iOS 17+ only |
| CoreData | Mature, powerful | Complex, verbose, legacy feel |
| UserDefaults | Dead simple | Not meant for arrays of objects |
| JSON files | Full control | Manual, error-prone |

---

## New Swift Concepts You'll Learn

### 1. `@Model` Macro

The `@Model` macro transforms a regular Swift class into a persistent model. SwiftData automatically tracks changes and saves them.

```swift
import SwiftData

@Model
class Goal {
    var id: UUID
    var content: String
    var reason: String
    var createdAt: Date
    var completedDates: [Date]

    init(content: String, reason: String) {
        self.id = UUID()
        self.content = content
        self.reason = reason
        self.createdAt = Date()
        self.completedDates = []
    }
}
```

**Key change:** `struct` → `class`. SwiftData requires classes because it needs reference semantics to track changes.

---

### 2. `ModelContainer`

A container that holds your data store. You create it once at app launch and inject it into SwiftUI.

```swift
import SwiftUI
import SwiftData

@main
struct cueApp: App {
    var body: some Scene {
        WindowGroup {
            VerticalPager()
        }
        .modelContainer(for: Goal.self)  // One line!
    }
}
```

This creates a SQLite database automatically. That's it.

---

### 3. `@Query` Property Wrapper

Fetches data from the database. It's reactive — your UI updates automatically when data changes.

```swift
struct VerticalPager: View {
    @Query var goals: [Goal]  // Automatically fetched!

    var body: some View {
        ForEach(goals) { goal in
            GoalView(goal: goal)
        }
    }
}
```

You can also sort and filter:

```swift
@Query(sort: \Goal.createdAt, order: .reverse) var goals: [Goal]
```

---

### 4. `@Environment(\.modelContext)`

The context is how you **create**, **update**, and **delete** objects.

```swift
struct SomeView: View {
    @Environment(\.modelContext) private var context

    func createGoal() {
        let goal = Goal(content: "Exercise", reason: "Health")
        context.insert(goal)
        // Saved automatically!
    }

    func deleteGoal(_ goal: Goal) {
        context.delete(goal)
    }
}
```

No manual "save" call needed — SwiftData auto-saves.

---

### 5. `@Observable` (for ViewModels)

If you want a ViewModel layer (optional but clean), use `@Observable`:

```swift
import Observation

@Observable
class GoalManager {
    var selectedGoal: Goal?
    var isShowingCreateSheet = false
}
```

Then in views:

```swift
struct SomeView: View {
    @State private var manager = GoalManager()
    // ...
}
```

---

## Step-by-Step Implementation

### Phase 1: Convert the Model

**File:** `Models/Goal.swift`

1. Change `struct` to `class`
2. Add `import SwiftData`
3. Add `@Model` macro
4. Remove `Codable` and `Hashable` (SwiftData handles this)
5. Keep `Identifiable` (still useful)
6. Move computed properties (`isCompletedToday`, `calculateStreak`) into the class

---

### Phase 2: Configure the Container

**File:** `cueApp.swift`

1. Add `import SwiftData`
2. Add `.modelContainer(for: Goal.self)` to WindowGroup

---

### Phase 3: Update Views to Use @Query

**File:** `Views/VerticalPager.swift`

1. Replace hardcoded `demoGoals` with `@Query var goals: [Goal]`
2. Handle empty state (when user has no goals yet)

---

### Phase 4: Add Create Functionality

**File:** `Views/Start.swift` (or create `Views/CreateGoalView.swift`)

1. Add `@Environment(\.modelContext)`
2. Add text fields for content and reason
3. On submit: `context.insert(newGoal)`

---

### Phase 5: Add Delete Functionality

**File:** `Views/GoalView.swift` or `Components/GoalCard.swift`

1. Add `@Environment(\.modelContext)`
2. Add swipe-to-delete or delete button
3. Call `context.delete(goal)`

---

### Phase 6: Update Completion Logic

**File:** `Views/GoalView.swift`

1. When slider completes, append `Date()` to `goal.completedDates`
2. SwiftData auto-saves the change

---

## File Changes Summary

| File | Changes |
|------|---------|
| `Models/Goal.swift` | Convert to `@Model` class |
| `cueApp.swift` | Add model container |
| `Views/VerticalPager.swift` | Use `@Query` instead of demo data |
| `Views/Start.swift` | Add form + create logic |
| `Views/GoalView.swift` | Add delete + update logic |

---

## Testing Tip

When developing, you can use an in-memory store to avoid persisting test data:

```swift
.modelContainer(for: Goal.self, inMemory: true)
```

Switch to `inMemory: false` (or remove it) for production.

---

## What We're NOT Doing (Keep It Simple)

- No CloudKit sync (can add later)
- No migrations (not needed for v1)
- No complex relationships (one model is enough)
- No ViewModel layer initially (can add if needed)

---

## Order of Implementation

1. **Model conversion** — Get `@Model` working
2. **Container setup** — Wire up the app
3. **Read** — Display persisted goals with `@Query`
4. **Create** — Add new goals
5. **Update** — Mark goals complete
6. **Delete** — Remove goals

Start with steps 1-3. Get data showing. Then add create/delete.

---

## Questions to Consider

- Do you want goals sorted by creation date or custom order?
- Should completed goals be archived or deleted?
- Do you want categories/tags later? (Keep model simple for now)
