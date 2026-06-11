## Context

The project is a HarmonyOS API 20 (SDK 6.0.0) Stage Model app with one page (`pages/Index`) that displays a static, hardcoded list of 5 songs. There is no audio playback, no navigation, and no state management. The app uses Component V2 (`@ComponentV2`) and standard ArkUI components. The data model is a simple `Song` interface with `name`, `artist`, and `picture` fields.

This design outlines how to evolve the app into a functional local music player while keeping the architecture straightforward and aligned with HarmonyOS best practices.

## Goals / Non-Goals

**Goals:**
- Enable playback of local audio files using AVPlayer
- Provide a full-screen Now Playing page with transport controls and progress tracking
- Add a persistent mini-player bar on the song list page
- Support next/previous track navigation and auto-advance
- Implement sequential, shuffle, repeat-one, and repeat-all play modes
- Integrate AVSession for background playback and system media controls
- Keep the existing song list UI largely intact

**Non-Goals:**
- Online streaming or network audio sources
- Playlist creation, editing, or deletion by the user
- Favorites, ratings, or user preferences
- Equalizer or audio effects
- Lyrics display
- Media library scanning (files remain hardcoded)
- Data persistence across app restarts (playback state is ephemeral)

## Decisions

### 1. Singleton AudioPlayerManager for shared playback state

Use a singleton class `AudioPlayerManager` that owns the AVPlayer instance and exposes reactive state via `@ObservedV2` + `@Trace`. Components consume it through a module-level instance.

**Rationale**: AVPlayer is a heavyweight object — a single instance avoids duplicate resource usage. A singleton is the simplest pattern that works across pages without a dependency injection framework. Using `@ObservedV2` aligns with the existing `@ComponentV2` usage and provides fine-grained reactivity.

**Alternatives considered**: `@Provide/@Consume` (too tightly coupled to component hierarchy), `@StorageLink` (works but less type-safe for complex objects).

### 2. Separate NowPlaying page with router navigation

Use `@ohos.router.pushUrl()` to navigate from song list to NowPlaying page, and `router.back()` to return.

**Rationale**: Standard HarmonyOS navigation pattern. A separate page gives NowPlaying a full-screen canvas and clean lifecycle. The mini-player on the song list remains visible when the user navigates back.

**Alternatives considered**: Inline expandable panel (limits screen real estate for album art), Navigation component with NavPathStack (overkill for 2 pages).

### 3. Local audio files in `resources/rawfile/`

Place sample audio files (`.mp3`) in `entry/src/main/resources/rawfile/` and reference them via `$rawfile('filename.mp3')`. The AVPlayer loads these through the resource manager.

**Rationale**: `rawfile` is the standard HarmonyOS location for arbitrary file assets. AVPlayer can load from rawfile via a file descriptor obtained from the resource manager. This avoids filesystem permissions complexity.

**Alternatives considered**: External storage paths (requires user permissions, not appropriate for bundled sample audio), network URLs (adds complexity, not needed for local player).

### 4. Play mode as an enum cycled by a single button

Define `PlayMode` enum: `SEQUENTIAL → SHUFFLE → REPEAT_ONE → REPEAT_ALL → SEQUENTIAL`. A single button on the Now Playing page cycles through modes with a toast/icon indicating the current mode.

**Rationale**: Common music player UX pattern. Avoids multiple toggle buttons and saves control bar space.

**Alternatives considered**: Separate toggle buttons (clutters UI), dropdown menu (extra tap to change).

### 5. AVSession created once and updated on track changes

Initialize AVSession in the AudioPlayerManager when playback starts. Update metadata (title, artist, album art pixel map) on each track change. Register command listeners for system play/pause/next/previous.

**Rationale**: AVSession is a system-level service. One session per app is the intended pattern. Updating metadata avoids tearing down and recreating the session.

### 6. Mini-player visibility tied to playback state

The mini-player at the bottom of the song list is visible when a song has been selected (played or paused). It hides when no song has ever been played in the current session.

**Rationale**: Prevents an empty mini-player from occupying screen space before the user interacts with the app. Standard behavior in music apps (e.g., Spotify, Apple Music).

## Risks / Trade-offs

- **AVPlayer lifecycle complexity**: AVPlayer has many state transitions (initialized → prepared → playing → paused → stopped → released). Improper handling can cause crashes. → Mitigation: Wrap in a manager class with well-defined state machine, thorough state validation before each operation.
- **Audio file availability**: The app has only one image asset. Actual `.mp3` files need to be sourced or generated. → Mitigation: Use short silent/test audio files for development; document the asset requirement clearly.
- **AVSession compatibility**: AVSession APIs may have device-specific behavior differences. → Mitigation: Target phone/tablet device types as already declared in `module.json5`; test on physical device.
- **No background task for audio**: HarmonyOS may restrict background execution. → Mitigation: AVSession with media session type automatically grants background audio capability; no additional permissions needed for local playback.

## Open Questions

- Should the mini-player show a progress bar or only play/pause? (Leaning: play/pause only, progress bar on Now Playing page)
- Should tapping a song from the list auto-navigate to Now Playing, or just start playing in the background? (Leaning: auto-navigate, consistent with most music apps)
