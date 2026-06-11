## 1. Data Model & Assets

- [x] 1.1 Extend `Song` interface in `common/interface/song.ets` with `id`, `duration`, `audio` (Resource), and `sourcePath` fields
- [x] 1.2 Add sample `.mp3` audio files to `entry/src/main/resources/rawfile/` for the 5 hardcoded songs
- [x] 1.3 Update the `songList` array in `Index.ets` with the new fields referencing the rawfile audio resources

## 2. Audio Playback Engine

- [x] 2.1 Create `common/manager/AudioPlayerManager.ets` as an `@ObservedV2` singleton class with `@Trace` state properties (`isPlaying`, `currentTime`, `totalDuration`, `currentSong`, `playMode`, `playbackState`)
- [x] 2.2 Implement AVPlayer lifecycle: `load()`, `play()`, `pause()`, `stop()`, `seek()`, `release()` methods with proper state validation
- [x] 2.3 Register AVPlayer state change and time update callbacks, mapping them to the manager's reactive properties
- [x] 2.4 Implement `onTrackComplete` callback logic that triggers auto-advance based on current play mode

## 3. Mini Player Component

- [x] 3.1 Create `common/components/MiniPlayer.ets` as a `@ComponentV2` with album art thumbnail, song name, artist, play/pause button, and next button
- [x] 3.2 Bind play/pause and next button actions to `AudioPlayerManager`
- [x] 3.3 Implement tap-on-info-area to navigate to Now Playing page via `router.pushUrl()`
- [x] 3.4 Control visibility: show when `currentSong` is set, hide otherwise with a smooth layout transition
- [x] 3.5 Integrate `MiniPlayer` into `Index.ets` at the bottom of the page layout

## 4. Now Playing Page

- [x] 4.1 Create `pages/NowPlaying.ets` as an `@Entry` page with full-screen dark theme layout
- [x] 4.2 Implement album art display (large, centered in upper portion) bound to current song
- [x] 4.3 Implement song name and artist text display below album art
- [x] 4.4 Implement progress slider bound to `currentTime`/`totalDuration` with drag-to-seek interaction
- [x] 4.5 Display current time and total duration labels (formatted as `mm:ss`)
- [x] 4.6 Implement transport controls row: previous, play/pause (large, centered), next buttons
- [x] 4.7 Implement play mode toggle button with cycling icons for each mode
- [x] 4.8 Add back button / system back gesture to navigate back to song list
- [x] 4.9 Register `pages/NowPlaying` route in `main_pages.json`

## 5. Playlist Navigation

- [x] 5.1 Add `onClick` handler to each `ListItem` in the song list to set the tapped song as current and start playback via `AudioPlayerManager`
- [x] 5.2 Navigate to Now Playing page after tapping a song in the list
- [x] 5.3 Visually highlight the currently playing song in the list (e.g., accent-colored text or playing icon)
- [x] 5.4 Implement next-track and previous-track logic in `AudioPlayerManager` based on playlist index
- [x] 5.5 Implement restart-current-track logic: previous button restarts if `currentTime >= 3s`, otherwise goes to previous track

## 6. Play Modes

- [x] 6.1 Define `PlayMode` enum (`SEQUENTIAL`, `SHUFFLE`, `REPEAT_ONE`, `REPEAT_ALL`) in a shared constants file
- [x] 6.2 Implement sequential mode: advance by index, stop after last track
- [x] 6.3 Implement shuffle mode: generate random order, track played indices to avoid repeats within a cycle
- [x] 6.4 Implement repeat-one mode: reload and replay the same track on completion
- [x] 6.5 Implement repeat-all mode: wrap to first track after last track completes
- [x] 6.6 Implement mode cycling logic and expose current mode from `AudioPlayerManager`

## 7. Media Session (AVSession)

- [x] 7.1 Create `common/manager/AVSessionController.ets` to manage AVSession lifecycle
- [x] 7.2 Initialize AVSession with type "audio" when playback first starts
- [x] 7.3 Update AVSession metadata (title, artist, album art pixel map) on each track change
- [x] 7.4 Register command listeners for system play, pause, next, previous, and seek commands, delegating to `AudioPlayerManager`
- [ ] 7.5 Verify background playback: audio continues when app is minimized
- [ ] 7.6 Verify lock screen controls display song info and respond to transport commands

## 8. Integration & Polish

- [x] 8.1 Ensure smooth transition animations between song list and Now Playing page
- [x] 8.2 Handle edge case: tapping the same song that is already playing (navigate without restart)
- [x] 8.3 Handle edge case: playlist exhausted in sequential mode (show appropriate UI state)
- [x] 8.4 Handle AVPlayer errors gracefully with user-facing error messages (toasts)
- [ ] 8.5 Test full flow: launch → tap song → play → pause → next → back to list → mini-player → tap to reopen
- [ ] 8.6 Test play mode cycling: sequential → shuffle → repeat-one → repeat-all → sequential
