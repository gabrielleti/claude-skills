# Apple HIG — Routing Table

> **This file is a map, not a source of truth.** It tells you *which* HIG page answers a
> question; the answer itself is always fetched live from Apple. Never quote a rule from
> memory or from this file — fetch the page and quote that.

## How to fetch

```bash
scripts/hig-fetch.sh <slug>     # renders the live page as Markdown
scripts/hig-fetch.sh --list     # all 135 slugs, straight from Apple's index
```

The script hits `developer.apple.com/tutorials/data/design/human-interface-guidelines/<slug>.json`
— the same DocC JSON API the API reference uses, just under `/design/` instead of
`/documentation/`. Nothing is cached; every call is live.

Do not use WebFetch on `developer.apple.com/design/...` — those pages are JavaScript-rendered
and return only the page title.

## Question → slug

| When you're deciding… | Fetch |
|---|---|
| Font sizes, text styles, Dynamic Type | `typography` |
| Colors, semantic colors, contrast | `color`, `dark-mode` |
| Spacing, margins, safe areas, hit targets | `layout` |
| Blur, vibrancy, translucency | `materials` |
| Animation, transitions, Reduce Motion | `motion` |
| Icons in the UI | `sf-symbols`, `icons` |
| The app icon itself | `app-icons` |
| VoiceOver, Dynamic Type, contrast, Switch Control | `accessibility`, `voiceover`, `inclusion` |
| Haptic feedback | `playing-haptics` |
| Progress, spinners, skeleton states | `loading` |
| Success/error/confirmation feedback | `feedback` |
| First-run experience, permission priming | `onboarding`, `launching` |
| Sheets, popovers, alerts, full-screen covers | `modality`, `presentation` |
| Tab bars, sidebars, navigation | `tab-bars`, `sidebars`, `navigation-and-search` |
| Buttons, toggles, sliders, pickers | `buttons`, `toggles`, `sliders`, `selection-and-input` |
| Forms and text entry | `entering-data`, `keyboards`, `token-fields` |
| Charts and data visualization | `charting-data` |
| Live Activities, Dynamic Island | `live-activities`, `live-viewing-apps` |
| Widgets and complications | `widgets`, `complications` |
| Subscriptions, paywalls, purchases | `in-app-purchase` |
| Health data | `healthkit` |
| Camera and photo capture | `camera-control`, `photo-editing` |
| AI/ML features | `generative-ai`, `machine-learning` |
| Privacy prompts, tracking, data use | `privacy` |
| Notifications | `managing-notifications` |
| Search | `searching`, `search-fields` |
| Settings screens | `settings` |
| Platform conventions | `designing-for-ios`, `designing-for-ipados`, `designing-for-macos`, `designing-for-watchos`, `designing-for-visionos`, `designing-for-tvos` |
| The six HIG pillars | `design-principles` |

## All slugs

Every one of these resolves; run `--list` to re-derive the set from Apple.

**Foundations** — `accessibility` `app-icons` `branding` `color` `dark-mode` `foundations`
`icons` `images` `immersive-experiences` `inclusion` `layout` `materials` `motion` `privacy`
`right-to-left` `sf-symbols` `spatial-layout` `typography` `writing`

**Components** — `activity-views` `buttons` `components` `content` `context-menus`
`disclosure-controls` `dock-menus` `layout-and-organization` `menus` `menus-and-actions`
`navigation-and-search` `ornaments` `page-controls` `pop-up-buttons` `presentation`
`pull-down-buttons` `scroll-views` `search-fields` `selection-and-input` `sidebars` `sliders`
`split-views` `status` `system-experiences` `tab-bars` `tab-views` `the-menu-bar` `toggles`
`token-fields` `toolbars` `windows`

**Patterns** — `charting-data` `collaboration-and-sharing` `drag-and-drop` `entering-data`
`feedback` `file-management` `going-full-screen` `launching` `live-viewing-apps` `loading`
`managing-accounts` `managing-notifications` `modality` `multitasking` `offering-help`
`onboarding` `patterns` `playing-audio` `playing-haptics` `playing-video` `printing`
`ratings-and-reviews` `searching` `settings` `undo-and-redo` `workouts`

**Inputs** — `action-button` `apple-pencil-and-scribble` `camera-control` `digital-crown`
`eyes` `focus-and-selection` `game-controls` `gestures` `gyro-and-accelerometer` `inputs`
`keyboards` `nearby-interactions` `pointing-devices` `remotes`

**Technologies** — `airplay` `always-on` `app-clips` `app-shortcuts` `apple-pay`
`augmented-reality` `carekit` `carplay` `complications` `game-center` `generative-ai`
`healthkit` `home-screen-quick-actions` `homekit` `icloud` `id-verifier`
`imessage-apps-and-stickers` `in-app-purchase` `live-activities` `live-photos`
`mac-catalyst` `machine-learning` `maps` `nfc` `photo-editing` `researchkit` `shareplay`
`shazamkit` `sign-in-with-apple` `siri` `tap-to-pay-on-iphone` `technologies` `voiceover`
`wallet` `widgets`

**Platforms & meta** — `design-principles` `designing-for-games` `designing-for-ios`
`designing-for-ipados` `designing-for-macos` `designing-for-tvos` `designing-for-visionos`
`designing-for-watchos` `getting-started` `snippets`

## What this file deliberately does not contain

Point values, spacing grids, minimum tap targets, contrast ratios, font size tables. Those
change, and a stale number quoted with confidence is worse than no number. Fetch the page.
