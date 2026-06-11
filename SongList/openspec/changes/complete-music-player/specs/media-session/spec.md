## ADDED Requirements

### Requirement: Create and manage AVSession

The system SHALL create an AVSession when playback starts and keep it active throughout the playback session.

#### Scenario: AVSession created on playback start

- **WHEN** the first song begins playing
- **THEN** an AVSession is created with type "audio" and activated

#### Scenario: AVSession released on app exit

- **WHEN** the app is terminated
- **THEN** the AVSession is deactivated and released

### Requirement: Set media metadata

The system SHALL update the AVSession metadata with the current song's title, artist, and album art whenever the track changes.

#### Scenario: Metadata updated on track change

- **WHEN** playback switches to a different song
- **THEN** the AVSession metadata is updated with the new song's title, artist name, and album art

### Requirement: Handle system transport commands

The system SHALL respond to play, pause, next, and previous commands sent from the system (lock screen, notification center, headset controls).

#### Scenario: System play command

- **WHEN** the system sends a play command via AVSession
- **THEN** the app resumes playback if paused

#### Scenario: System pause command

- **WHEN** the system sends a pause command via AVSession
- **THEN** the app pauses playback

#### Scenario: System next command

- **WHEN** the system sends a next-track command via AVSession
- **THEN** the app advances to the next track

#### Scenario: System previous command

- **WHEN** the system sends a previous-track command via AVSession
- **THEN** the app navigates to the previous track or restarts the current track

### Requirement: Background playback

The system SHALL continue audio playback when the app is moved to the background.

#### Scenario: Playback continues in background

- **WHEN** the user switches away from the app while a song is playing
- **THEN** audio playback continues uninterrupted

### Requirement: Lock screen media controls

The system SHALL expose media controls on the lock screen when audio is playing.

#### Scenario: Lock screen shows controls

- **WHEN** a song is playing and the device is locked
- **THEN** the lock screen displays the song title, artist, and play/pause/next/previous controls
