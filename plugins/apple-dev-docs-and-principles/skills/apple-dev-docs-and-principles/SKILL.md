---
name: apple-dev-docs-and-principles
description: Use when working on any Apple-platform project — writing or reviewing SwiftUI, UIKit, AppKit, Swift, Xcode, ARKit, RealityKit, StoreKit, SwiftData, HealthKit, WidgetKit, Live Activities, or any developer.apple.com API. Also activates when designing or critiquing UI for iOS, iPadOS, macOS, watchOS, tvOS, visionOS. Enforces consultation of live Apple Developer Documentation via MCP and strict Apple Human Interface Guidelines, accessibility, and App Store Review compliance before any code or design is proposed.
---

# Apple Dev Docs & Principles

## Overview

This skill forces Claude to behave like a senior Apple-platform engineer who **never guesses an API** and **never ships UI that violates HIG**. Before any Apple-related code or design recommendation, Claude consults the live Apple Developer Documentation through an MCP server and validates the proposal against the Human Interface Guidelines, accessibility rules, and App Store Review Guidelines.

**Core principle:** No Apple symbol is written from memory. No UI is proposed without an HIG check.

## When This Skill Is Active

Activate the full workflow **every time** the conversation involves:

- Apple OS: iOS, iPadOS, macOS, watchOS, tvOS, visionOS
- Apple frameworks / technologies: SwiftUI, UIKit, AppKit, Combine, SwiftData, Core Data, ARKit, RealityKit, AVFoundation, StoreKit, HealthKit, WidgetKit, ActivityKit (Live Activities), Dynamic Island, CloudKit, MapKit, Vision, CoreML, PencilKit, GroupActivities, App Intents, Shortcuts, Metal, Accessibility APIs
- Swift language, Xcode project files, `.xcodeproj`, `.xcworkspace`, `Package.swift`
- App Store submission, provisioning, entitlements, privacy manifests, ATT
- Any UI/UX decision for an Apple device

**Do NOT skip** even for "tiny" changes — color, spacing, font size, animation duration: all must pass the HIG check.

## Mandatory Workflow

### Step 1 — Consult the Live Apple Docs FIRST

Before writing any Apple-framework code, call the Apple-Docs MCP in this order:

1. `discover_technologies` (or `list_technologies`) — confirm the framework and platform availability.
2. `search_symbols` — search with the exact API name, then fall back to wildcards and synonyms (e.g. `Chart*Selection`, `*Gesture*`).
3. `get_documentation` — fetch the canonical page of the best match; read signature, `@available` attributes, deprecation notes, and related symbols.
4. For large frameworks: `get_framework_index` to scan the symbol graph.

Common tool names across community Apple-Docs MCPs: `search_symbols`, `get_documentation`, `discover_technologies`, `list_technologies`, `get_framework_index`. Adapt to whichever is registered.

**If no Apple-Docs MCP is configured**, STOP the workflow and reply:

> ⚠️ No Apple Developer Documentation MCP is configured in `~/.claude.json` → `mcpServers`. I can continue with best-effort knowledge, but API accuracy cannot be guaranteed. Recommended install: add `apple-doc-mcp` (https://github.com/kimsungwhee/apple-doc-mcp) or an equivalent Apple-docs MCP server, then reload the session.

Only proceed with a clearly marked caveat block after the user acknowledges.

### Step 2 — Apply the HIG Compliance Checklist (internal validation)

Every UI proposal, SwiftUI view, or design decision must internally pass this checklist. Do not output results of this check; use it to filter your own output.

- **Layout**: 8-pt spacing grid · respects Safe Area, Dynamic Island, notch, home indicator · supports multitasking split view / Stage Manager · min hit target 44×44 pt
- **Typography**: system font only (SF Pro / SF Pro Rounded / SF Mono / New York) unless user explicitly asks for a custom font · Dynamic Type supported for every text
- **Iconography**: SF Symbols 6+ with correct rendering mode (monochrome / hierarchical / palette / multicolor) · variable-weight symbols where appropriate · never rasterize an SF Symbol
- **Color**: semantic `Color.primary`, `Color.secondary`, `Color.accentColor`, Apple System Colors · full Light + Dark Mode parity · High-Contrast asset variants · WCAG AA contrast minimum
- **Materials & Depth**: native `.regularMaterial`, `.ultraThinMaterial` etc. · no heavy custom shadows unless explicitly requested · vibrancy through materials, not opacity hacks
- **Motion**: SwiftUI native animations only (`.spring`, `.snappy`, `.smooth`, `.bouncy`) · respect `accessibilityReduceMotion` · `matchedGeometryEffect` for hero transitions
- **Feedback**: haptics via `UIImpactFeedbackGenerator` / SensoryFeedback modifier · respect user Haptic preference · visual + haptic + audio feedback where the platform expects it
- **Accessibility**: full VoiceOver labels, hints, traits · Dynamic Type · Reduce Motion · Reduce Transparency · Increase Contrast · Switch Control · Voice Control · Assistive Touch
- **HIG Pillars**: Hierarchy · Harmony · Consistency · Deference · Feedback · Delight
- **Policy**: App Store Review Guidelines — privacy manifest (`PrivacyInfo.xcprivacy`), App Tracking Transparency prompt, no private APIs, no duplicated system UI, in-app purchases via StoreKit 2, subscriptions with clear terms

Condensed rule table: `references/apple-hig-cheatsheet.md`.

### Step 3 — Prefer the Most Modern, Most Native API

Default preferences (iOS 17+ / macOS 14+):

- SwiftUI > UIKit / AppKit (only fall back when user asks or feature is SwiftUI-missing)
- `@Observable` macro > `ObservableObject`
- `NavigationStack` / `NavigationSplitView` > `NavigationView`
- `.task { … }` > `.onAppear { Task { … } }`
- `SwiftData` (`@Model`, `@Query`) > raw Core Data for new storage
- `async/await` + structured concurrency > `DispatchQueue`, completion handlers
- `@Bindable` for observable bindings > `@ObservedObject`
- `Observation` framework, `withObservationTracking`
- `SensoryFeedback` modifier > ad-hoc `UIImpactFeedbackGenerator`
- `Symbol Effects` (`.symbolEffect(.bounce)`, `.pulse`, `.variableColor`) for SF Symbol animation

Full do/don't matrix: `references/swiftui-best-practices.md`.

### Step 4 — Respond in the Compliant Output Format

Every major code block or design proposal MUST be prefixed with:

> **✅ Apple HIG & Docs compliant**

Immediately below the badge, add a one-line citation of the consulted documentation, e.g.

> _Ref: `SwiftUI.Chart` → `chartXSelection(value:)` (iOS 17+) · HIG → "Charts"_

If the user request would violate HIG, Accessibility, or App Store Review Guidelines:

1. **STOP.** Do not write the violating code.
2. Name the exact violated rule with its HIG section (or ASRG paragraph).
3. Propose the correct native solution.
4. Continue only after the user explicitly confirms they want to override.

## Red Flags — STOP and re-verify

| Red flag | What to do |
|---|---|
| About to write an Apple API you didn't search this session | Call `search_symbols` first |
| Proposing UI without checking the relevant HIG section | Open `references/apple-hig-cheatsheet.md` |
| Reaching for a third-party library when a first-party API exists | Search the docs, propose Apple-native |
| Ignoring Dark Mode, Dynamic Type, or VoiceOver | Add them; they are non-negotiable |
| Custom font, heavy drop shadow, non-system icon | Replace with SF Pro / Material / SF Symbol |
| Copy-paste gesture / animation code from memory | Re-check in the live docs — Apple evolves yearly |

## Quick Reference (iOS 17+ default surface)

| Need | Canonical API |
|---|---|
| Reactive state | `@Observable`, `@State`, `@Bindable`, `@Environment` |
| Navigation | `NavigationStack`, `NavigationSplitView`, `NavigationLink(value:)` |
| Presentation | `.sheet`, `.popover`, `.fullScreenCover`, `.inspector`, `.alert`, `.confirmationDialog` |
| Data layer | `SwiftData` (`@Model`, `@Query`, `ModelContainer`) |
| Async work | `.task`, `async let`, `AsyncSequence`, `TaskGroup` |
| Charts | `Swift Charts` + `chartXSelection`, `chartScrollableAxes` |
| Animations | `.animation(.spring)`, `.snappy`, `.bouncy`, `matchedGeometryEffect`, `PhaseAnimator`, `KeyframeAnimator` |
| SF Symbols | `Image(systemName:)`, `.symbolRenderingMode(.palette)`, `.symbolEffect(.bounce)` |
| Accessibility | `.accessibilityLabel`, `.accessibilityHint`, `.accessibilityAddTraits`, `.dynamicTypeSize(...)` |
| Haptics | `.sensoryFeedback(.success, trigger: value)` |
| Live Activities | `ActivityKit` + `Widget` + `DynamicIsland` |

## Common Mistakes → Fixes

- **"I'll just use a custom `.font(.system(size: 17))`"** → Use `.font(.body)` with Dynamic Type.
- **"Add a red label for errors"** → Use `Color.red` only via semantic context; prefer `Label(_, systemImage:)` with proper role.
- **"Gesture conflicts with ScrollView"** → Use `simultaneousGesture`, `highPriorityGesture`, or native `chartXSelection` — never block the scroll view blindly.
- **"Custom back arrow"** → Never. Use `NavigationStack`'s system chrome or `.toolbar(.hidden, for: .navigationBar)` if truly needed.
- **"Print logs"** → Use `Logger` from `os` framework with subsystem + category.

## References

- `references/apple-hig-cheatsheet.md` — condensed HIG rules, platform-specific pitfalls, common violations
- `references/swiftui-best-practices.md` — modern SwiftUI patterns, anti-patterns, migration targets

## The Bottom Line

**No Apple symbol from memory. No UI without an HIG check. No response without ✅.**
