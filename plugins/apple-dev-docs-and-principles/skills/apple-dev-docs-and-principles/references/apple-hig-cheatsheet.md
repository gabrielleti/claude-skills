# Apple HIG Cheatsheet

> Condensed working reference. Authoritative source: https://developer.apple.com/design/human-interface-guidelines

## Foundations

| Topic | Rule |
|---|---|
| Spacing | 8-pt grid (4-pt sub-grid for tight layouts) |
| Hit target | ≥ 44 × 44 pt for any tappable element |
| Safe area | Always respect; use `.ignoresSafeArea(edges:)` only when visually intentional |
| Corner radius | Match the platform: iOS buttons ≈ 8–12 pt, cards ≈ 16–20 pt, containers follow device corner (continuous corner) |
| Margins | Use `.padding()` defaults or `ViewThatFits`; horizontal page margin ≈ 16–20 pt on iPhone |

## Typography

- **System fonts only** unless explicitly approved: SF Pro, SF Pro Rounded, SF Mono, New York.
- Use **text styles** (`.largeTitle`, `.title`, `.headline`, `.body`, `.callout`, `.subheadline`, `.footnote`, `.caption`, `.caption2`) — never raw point sizes.
- **Dynamic Type**: every text element must scale. Test at `accessibility5` size.
- Line length: 40–70 characters; use `.multilineTextAlignment(.leading)` by default.
- Localization: right-to-left mirroring, wider German strings (+35 %), avoid fixed widths.

## Color

- **Semantic first**: `Color.primary`, `.secondary`, `.accentColor`, `.tint`, `Color(.systemBackground)`.
- **System palette**: `.red`, `.orange`, `.yellow`, `.green`, `.mint`, `.teal`, `.cyan`, `.blue`, `.indigo`, `.purple`, `.pink`, `.brown`, `.gray`.
- **Dark Mode parity** is mandatory. Supply asset catalog variants for every brand color.
- **High-Contrast variants** for every custom color.
- **Contrast**: text ≥ 4.5:1 (body) / 3:1 (large text); non-text UI ≥ 3:1.
- Never use color as the **only** indicator — always pair with label, icon, or shape.

## Iconography

- **SF Symbols 6+** — 6000+ symbols, variable weights, hierarchical/palette/multicolor.
- Use `Image(systemName:)`; never rasterize.
- Rendering mode must match the context: monochrome for single-color, palette for multi-hue brand, hierarchical for depth.
- Animate with `.symbolEffect(.bounce, options: .nonRepeating)`, `.pulse`, `.variableColor.iterative`.
- Custom icons: export as PDF (single scale) or SVG, respect platform baseline (17 pt for navbar, 28 pt for tab bar).

## Layout & Navigation (per platform)

### iOS / iPadOS
- `NavigationStack` for push flows, `NavigationSplitView` for multi-column (iPad, Mac Catalyst).
- `TabView` for top-level switching (3–5 tabs, never more than 5 on iPhone).
- Dynamic Island: opt-in via `ActivityKit`; reserve for user-initiated live tasks.
- Device safe areas: notch, Dynamic Island, home indicator (34 pt bottom).
- iPad: multitasking (Split View, Slide Over, Stage Manager); test at 1/2, 1/3, 2/3 widths.

### macOS
- Use toolbars, sidebars, inspectors. `NavigationSplitView` with 3 columns is canonical.
- Menu bar commands via `CommandMenu`.
- Window sizing: minWidth, idealWidth, maxWidth on `WindowGroup`.

### watchOS
- Minimal depth; use `TabView(.verticalPage)` or scroll.
- Digital Crown support: `.focusable()` + `.digitalCrownRotation`.
- Always-On Display: reduce brightness via `.luminanceReduced` environment.

### visionOS
- Use 3D materials (`.glassBackgroundEffect()`), ornaments, `RealityView`.
- Respect eye comfort: avoid small text, low contrast; min 20 pt.
- Hover effects are automatic — don't override unless needed.

### tvOS
- Focus engine drives navigation; use `.focusable()`, `.focusSection()`.
- Parallax on focused items; don't re-implement manually.

## Motion & Feedback

- Native SwiftUI animations only: `.animation(.spring)`, `.snappy`, `.smooth`, `.bouncy`, `.interactiveSpring`.
- Duration default: 0.3–0.5 s; never exceed 1 s for functional animation.
- **Respect `accessibilityReduceMotion`** — degrade to crossfade or no animation.
- Haptics via `.sensoryFeedback(.success, trigger:)`; respect user's haptic toggle.
- Sound: subtle, optional, never the sole feedback channel.

## Accessibility (non-negotiable)

| Feature | SwiftUI API |
|---|---|
| VoiceOver label | `.accessibilityLabel(_:)` |
| VoiceOver hint | `.accessibilityHint(_:)` |
| Traits | `.accessibilityAddTraits(.isButton)` |
| Group elements | `.accessibilityElement(children: .combine)` |
| Announce changes | `AccessibilityNotification.Announcement(...).post()` |
| Dynamic Type scaling | automatic with text styles; cap with `.dynamicTypeSize(...DynamicTypeSize.accessibility3)` |
| Reduce Motion | check `@Environment(\.accessibilityReduceMotion)` |
| Reduce Transparency | check `@Environment(\.accessibilityReduceTransparency)` |
| Differentiate without color | check `@Environment(\.accessibilityDifferentiateWithoutColor)` |

## App Store Review Guidelines — top violation risks

- **2.1 App Completeness** — no crashes, placeholder content, broken links.
- **2.3 Accurate Metadata** — screenshots must match shipped UI.
- **3.1.1** — in-app purchases only via StoreKit for digital goods.
- **4.0 Design** — copying system UI or Apple apps is rejected.
- **5.1.1 Privacy** — privacy manifest (`PrivacyInfo.xcprivacy`), nutrition labels, tracking prompt (ATT).
- **5.1.2 Data Use** — "Sign in with Apple" required if any third-party social sign-in is offered.

## Common Pitfalls

- ❌ Hard-coded `Color(red: 0.9, ...)` without Dark Mode variant
- ❌ `Font.custom("Helvetica", size: 15)` — breaks Dynamic Type
- ❌ Custom back chevron in NavigationStack
- ❌ Non-system tab bar icons for standard actions (Home, Search, Profile)
- ❌ Modal that blocks the status bar
- ❌ Drop shadows instead of Material
- ❌ `.onTapGesture` on non-button semantics without `.accessibilityAddTraits(.isButton)`
- ❌ `print(...)` in production; use `Logger`
- ❌ Force-unwrap optionals across the UI layer
- ❌ Blocking the main thread with synchronous I/O — use `.task`
