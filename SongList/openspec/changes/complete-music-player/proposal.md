## Why

The current app is a static song list with no playback capability — users can browse 5 hardcoded songs but cannot play, pause, or navigate between tracks. This change transforms the project into a functional music player, establishing the core audio infrastructure and UI patterns that future features (online streaming, playlists, favorites) can build upon.

## What Changes

- Add audio playback engine using HarmonyOS AVPlayer for local audio files
- Add a Now Playing full-screen page with album art, song info, progress bar, and transport controls (play/pause, previous, next)
- Add a mini-player bar anchored at the bottom of the song list, showing the current track with play/pause control
- Enable tap-to-play from the song list with automatic transition to now-playing view
- Implement sequential, shuffle, and repeat (single / all) play modes
- Integrate AVSession for lock screen / notification center media controls and background playback
- Separate UI into reusable components: mini-player, now-playing page, playback controls

## Capabilities

### New Capabilities
- `audio-playback`: Core playback engine using AVPlayer to load, play, pause, seek, and stop audio files
- `now-playing`: Full-screen player page displaying album art, song metadata, playback progress, and transport controls
- `mini-player`: Persistent bottom bar on the song list page showing current track info and inline play/pause
- `playlist-navigation`: Tap-to-play from song list, next/previous track switching, auto-advance on track completion
- `play-modes`: Sequential playback, shuffle, repeat-one, and repeat-all modes with mode cycling UI
- `media-session`: AVSession integration for system media controls, lock screen widget, and background audio continuation

### Modified Capabilities
<!-- No existing capabilities to modify -->

## Impact

- **New files**: NowPlaying page (`pages/NowPlaying.ets`), MiniPlayer component, audio playback service/manager, AVSession controller, play mode state management
- **Modified files**: `Index.ets` (integrate mini-player, add tap-to-play navigation), `song.ets` (extend Song interface with duration, audio source), `module.json5` (register new pages), `main_pages.json` (add now-playing route)
- **New dependencies**: `@ohos.multimedia.media` (AVPlayer), `@ohos.multimedia.avsession` (media session), `@ohos.router` (page routing)
- **Assets needed**: Sample audio files for the 5 hardcoded songs
