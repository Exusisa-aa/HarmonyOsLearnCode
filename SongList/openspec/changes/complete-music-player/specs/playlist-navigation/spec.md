## ADDED Requirements

### Requirement: Tap to play from song list

The system SHALL start playback and navigate to the Now Playing page when the user taps a song in the song list.

#### Scenario: Tap a song

- **WHEN** the user taps any song in the song list
- **THEN** that song begins playing and the app navigates to the Now Playing page

#### Scenario: Tap the currently playing song

- **WHEN** the user taps the song that is already selected as the current track
- **THEN** the app navigates to the Now Playing page without restarting playback

### Requirement: Highlight current song

The system SHALL visually distinguish the currently playing song in the song list from other songs.

#### Scenario: Current song highlighted

- **WHEN** a song is playing or paused
- **THEN** that song's list item shows a visual indicator (e.g., a colored accent or playing icon) differentiating it from other items

### Requirement: Next track navigation

The system SHALL play the next track in the playlist when the next-track action is triggered.

#### Scenario: Next track played

- **WHEN** the next-track action is triggered (via mini-player, Now Playing page, or system media control)
- **THEN** the next song in the playlist (according to play mode) becomes the current track and starts playing

### Requirement: Previous track navigation

The system SHALL play the previous track in the playlist when the previous-track action is triggered.

#### Scenario: Previous track within 3 seconds

- **WHEN** the previous-track action is triggered and the current playback position is less than 3 seconds
- **THEN** the previous song in the playlist becomes the current track

#### Scenario: Previous track after 3 seconds

- **WHEN** the previous-track action is triggered and the current playback position is 3 seconds or more
- **THEN** the current track restarts from the beginning

### Requirement: Auto-advance on track completion

The system SHALL automatically play the next track when the current track finishes playing.

#### Scenario: Auto-advance on end

- **WHEN** the current track reaches the end naturally
- **THEN** the next track (according to play mode) begins playing automatically
