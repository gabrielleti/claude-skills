# SwiftUI Best Practices (iOS 17+ / iOS 18 / iOS 26 target)

> Prefer SwiftUI over UIKit. Prefer the newest stable API over backports. Migrate aggressively.

## Observation & State

| Use | Instead of |
|---|---|
| `@Observable class ViewModel` | `class ViewModel: ObservableObject` + `@Published` |
| `@State private var vm = ViewModel()` | `@StateObject var vm = ViewModel()` |
| `@Bindable var vm: ViewModel` | `@ObservedObject var vm: ViewModel` |
| `@Environment(ViewModel.self)` | `@EnvironmentObject var vm: ViewModel` |

Rule: **One `@State` per root-of-truth**, pass down with `@Bindable` or `@Binding`. Avoid re-computing expensive values inside `body`; use `@State` + `.task(id:)`.

## Navigation

| Use | Instead of |
|---|---|
| `NavigationStack` + `NavigationLink(value:)` + `.navigationDestination(for:)` | `NavigationView` + `NavigationLink(destination:)` |
| `NavigationSplitView` (iPad / Mac) | custom multi-column |
| `.sheet(item:)` / `.fullScreenCover(item:)` | manual `isPresented` juggling when the presentation depends on data |
| `.inspector(isPresented:)` | ad-hoc side panel |

Never stack `NavigationView` inside `NavigationView`. Never push a `.sheet` from a `.sheet` without `presentationDetents`.

## Data (SwiftData)

```swift
@Model final class Scan {
    var id: UUID
    var createdAt: Date
    var imageData: Data?
    init(id: UUID = .init(), createdAt: Date = .now) { ... }
}

@main struct App: App {
    var body: some Scene {
        WindowGroup { RootView() }
            .modelContainer(for: Scan.self)
    }
}

struct RootView: View {
    @Query(sort: \Scan.createdAt, order: .reverse) var scans: [Scan]
    @Environment(\.modelContext) private var ctx
}
```

Prefer `SwiftData` for new persistence; use Core Data only for legacy stores or CloudKit-sync-with-history requirements. `@Query` supports `#Predicate`, `sort:`, and `animation:`.

## Concurrency

| Use | Instead of |
|---|---|
| `.task { await ... }` | `.onAppear { Task { await ... } }` |
| `.task(id: someValue) { ... }` (auto-cancel on id change) | manual cancellation plumbing |
| `async let a = ...; async let b = ...` | nested `await`s |
| `@MainActor` on ViewModels | `DispatchQueue.main.async` |
| Structured `TaskGroup` | unstructured `Task { }` trees |
| `AsyncStream` / `AsyncSequence` | Combine `PassthroughSubject` for new code |

Never call `DispatchQueue.main.async` from Swift concurrency code — it breaks cancellation and causes Sendable warnings.

## Animations

| Use | Instead of |
|---|---|
| `.animation(.spring, value: state)` | `withAnimation { ... }` at call site when the source of change is `state` |
| `.snappy`, `.bouncy`, `.smooth` (iOS 17 presets) | custom spring constants |
| `matchedGeometryEffect(id:in:)` | two separate animations of position + size |
| `PhaseAnimator` / `KeyframeAnimator` | timer-driven manual keyframes |
| `.transition(.symbolEffect)` on SF Symbols | crossfade hack |

Always respect `@Environment(\.accessibilityReduceMotion)`.

## Feedback

```swift
.sensoryFeedback(.success, trigger: scanCount)
.sensoryFeedback(.impact(weight: .medium), trigger: buttonTaps)
```

Use `UIImpactFeedbackGenerator` only when you need pre-iOS 17 support.

## Lists & Scroll

| Use | Instead of |
|---|---|
| `List { ForEach(items) { ... } }` with `.listStyle(.plain)` | `ScrollView { VStack { ForEach(...) } }` for data lists |
| `.scrollTargetBehavior(.paging)` / `.viewAligned` | manual offset math |
| `.scrollPosition(id:)` | `ScrollViewReader` + `.id` for new code |
| `ContentUnavailableView("No scans", systemImage: "camera")` | custom empty state |
| `.swipeActions` | custom drag gestures |
| `.refreshable { await ... }` | custom pull-to-refresh |

## Charts (Swift Charts)

```swift
Chart(dataPoints) { point in
    LineMark(x: .value("Day", point.date), y: .value("Value", point.v))
}
.chartXSelection(value: $selectedDate)     // native selection, no custom gesture layer
.chartScrollableAxes(.horizontal)
.chartScrollPosition(x: $scrollX)
.chartXVisibleDomain(length: 7 * 86_400)
```

**Never** overlay a custom `DragGesture` / `UIGestureRecognizer` on a Chart to implement selection — `chartXSelection` does it correctly, with Accessibility and Voice Control support baked in.

## Accessibility

- Every interactive element: `.accessibilityLabel`, `.accessibilityHint`, `.accessibilityAddTraits(.isButton)`.
- Decorative images: `.accessibilityHidden(true)` or `Image(decorative:)`.
- Compound rows: `.accessibilityElement(children: .combine)` to merge child labels.
- Test with: VoiceOver rotor, Voice Control ("show numbers"), Switch Control, Full Keyboard Access.

## Common Anti-Patterns

- ❌ `@StateObject var vm = ViewModel()` in a child view — use `@Bindable`.
- ❌ Mutating `@State` from outside the view — it won't propagate.
- ❌ Putting business logic in `body` — move to ViewModel or computed helper.
- ❌ `GeometryReader` as the root — it expands to parent's size and breaks layout; use `ViewThatFits`, `Layout` protocol, or `containerRelativeFrame`.
- ❌ `if let x = optional { ... }` inside `body` for large subtrees — extract to a helper view.
- ❌ Re-creating expensive objects in `body` (formatters, regex) — make them `static let`.
- ❌ `.frame(width: UIScreen.main.bounds.width)` — use `GeometryReader`, `containerRelativeFrame`, or geometry-aware layout.
- ❌ `print(...)` — use `Logger(subsystem: "com.app", category: "scan")`.

## Testing

- Unit tests: `swift-testing` (`@Test`, `#expect`, `#require`) > XCTest for new code.
- UI tests: `XCUITest`; prefer accessibility identifiers (`.accessibilityIdentifier("scanButton")`) over text lookups.
- Previews: `#Preview(traits:)` macro; add dark-mode + dynamic-type variants.

## Migration Targets (if you see this, upgrade)

| Legacy | Modern |
|---|---|
| `ObservableObject` | `@Observable` |
| `NavigationView` | `NavigationStack` / `NavigationSplitView` |
| `onAppear { Task { } }` | `.task { }` |
| `DispatchQueue.main.async` | `await MainActor.run` / `@MainActor` |
| Core Data (new features) | SwiftData |
| `UIImpactFeedbackGenerator` | `.sensoryFeedback(...)` |
| `ScrollViewReader` | `.scrollPosition(id:)` |
| Manual empty state | `ContentUnavailableView` |
