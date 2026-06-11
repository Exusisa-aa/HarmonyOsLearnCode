## ADDED Requirements

### Requirement: Load and play audio

The system SHALL load an audio file from the app's rawfile resources and begin playback when the play action is triggered.

#### Scenario: Play a song from rawfile

- **WHEN** the user taps a song in the song list
- **THEN** the system loads the corresponding audio file from `resources/rawfile/` via AVPlayer and starts playback

#### Scenario: Play fails due to missing file

- **WHEN** the specified audio file does not exist in rawfile resources
- **THEN** the system displays an error toast and falls back to a stopped state without crashing

### Requirement: Pause and resume playback

The system SHALL pause the currently playing audio and resume it from the same position.

#### Scenario: Pause playing audio

- **WHEN** the user taps the pause button while audio is playing
- **THEN** the AVPlayer pauses and retains the current playback position

#### Scenario: Resume paused audio

- **WHEN** the user taps the play button while audio is paused
- **THEN** the AVPlayer resumes playback from the paused position

### Requirement: Stop playback

The system SHALL stop playback and release the current audio resource when stopping.

#### Scenario: Stop playback

- **WHEN** the user triggers a stop action (e.g., switching to a different song)
- **THEN** the AVPlayer stops and resets, ready to load a new source

### Requirement: Seek to position

The system SHALL allow seeking to an arbitrary position within the current track.

#### Scenario: Seek forward

- **WHEN** the user drags the progress slider to a new position
- **THEN** the AVPlayer seeks to that position and continues playback from there

### Requirement: Report playback progress

The system SHALL report the current playback time and total duration at regular intervals while playing.

#### Scenario: Progress updates during playback

- **WHEN** a song is playing
- **THEN** the current time is updated at least once per second and the total duration is available after the track is prepared

### Requirement: Report playback state

The system SHALL expose the current playback state (idle, playing, paused, completed) to the UI layer.

#### Scenario: State change on play

- **WHEN** playback starts
- **THEN** the playback state changes to "playing" and all bound UI components reflect this

#### Scenario: State change on completion

- **WHEN** a track reaches the end
- **THEN** the playback state changes to "completed" before the next track logic executes
