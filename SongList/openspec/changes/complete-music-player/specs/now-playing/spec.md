## ADDED Requirements

### Requirement: Display album art

The system SHALL display the current song's album art prominently on the Now Playing page.

#### Scenario: Album art shown for current song

- **WHEN** the Now Playing page is displayed with a playing song
- **THEN** the song's album art image is rendered at a large size centered in the upper portion of the screen

### Requirement: Display song metadata

The system SHALL display the song name and artist name on the Now Playing page.

#### Scenario: Song info displayed

- **WHEN** the Now Playing page is active
- **THEN** the current song's name and artist are displayed below the album art

### Requirement: Progress bar with time labels

The system SHALL provide a seekable progress bar showing current playback position and a total duration label.

#### Scenario: Progress bar updates

- **WHEN** a song is playing on the Now Playing page
- **THEN** the progress slider position updates continuously and the current time label advances

#### Scenario: User seeks via progress bar

- **WHEN** the user drags the progress slider
- **THEN** playback seeks to the selected position and the time labels update accordingly

### Requirement: Transport controls

The system SHALL provide play/pause, previous, and next buttons on the Now Playing page.

#### Scenario: Play/pause toggle

- **WHEN** the user taps the play/pause button
- **THEN** playback toggles between playing and paused, and the button icon updates to reflect the new state

#### Scenario: Next track

- **WHEN** the user taps the next button
- **THEN** playback advances to the next track according to the current play mode

#### Scenario: Previous track

- **WHEN** the user taps the previous button
- **THEN** playback goes to the previous track, or restarts the current track if more than 3 seconds have elapsed

### Requirement: Play mode indicator and toggle

The system SHALL display the current play mode and allow the user to cycle through modes.

#### Scenario: Play mode displayed

- **WHEN** the Now Playing page is active
- **THEN** the current play mode icon (sequential, shuffle, repeat-one, repeat-all) is visible

#### Scenario: Cycle play mode

- **WHEN** the user taps the play mode button
- **THEN** the play mode advances to the next mode and the icon updates

### Requirement: Back navigation

The system SHALL allow the user to return to the song list from the Now Playing page.

#### Scenario: Navigate back

- **WHEN** the user taps the back button or performs a system back gesture
- **THEN** the app navigates back to the song list page with the mini-player visible
