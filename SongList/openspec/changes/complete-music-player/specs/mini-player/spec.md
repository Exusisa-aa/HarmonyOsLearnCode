## ADDED Requirements

### Requirement: Display current track info

The system SHALL display the current song's thumbnail, name, and artist in the mini-player bar at the bottom of the song list page.

#### Scenario: Mini-player shows current song

- **WHEN** a song is playing or paused
- **THEN** the mini-player bar is visible at the bottom of the song list, showing the song's album art thumbnail, name, and artist

### Requirement: Inline play/pause control

The system SHALL provide a play/pause button within the mini-player.

#### Scenario: Toggle playback from mini-player

- **WHEN** the user taps the play/pause button in the mini-player
- **THEN** playback toggles and the button icon updates accordingly

### Requirement: Skip to next track

The system SHALL provide a next-track button within the mini-player.

#### Scenario: Next track from mini-player

- **WHEN** the user taps the next button in the mini-player
- **THEN** playback advances to the next track according to the current play mode, and the mini-player updates to show the new song info

### Requirement: Navigate to Now Playing

The system SHALL navigate to the Now Playing page when the user taps the mini-player (outside the control buttons).

#### Scenario: Tap mini-player to open Now Playing

- **WHEN** the user taps the song info area of the mini-player
- **THEN** the app navigates to the Now Playing page via router

### Requirement: Visibility tied to playback state

The mini-player SHALL only be visible when a song has been selected for playback. It SHALL be hidden when no song has been selected.

#### Scenario: Mini-player hidden initially

- **WHEN** the app launches and no song has been played
- **THEN** the mini-player is not visible on the song list page

#### Scenario: Mini-player visible after playback starts

- **WHEN** a song starts playing
- **THEN** the mini-player becomes visible at the bottom of the song list page

### Requirement: Layout adaptation

The mini-player SHALL position itself above the system navigation bar and not overlap with the song list content.

#### Scenario: Mini-player does not overlap content

- **WHEN** the mini-player is visible
- **THEN** the song list content area adjusts so the last item is fully visible above the mini-player
