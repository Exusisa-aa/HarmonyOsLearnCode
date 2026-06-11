## ADDED Requirements

### Requirement: Sequential playback mode

The system SHALL support a sequential play mode where tracks play in list order and playback stops after the last track.

#### Scenario: Sequential mode plays in order

- **WHEN** the play mode is sequential and the current track finishes
- **THEN** the next track in the list starts playing

#### Scenario: Sequential mode stops at end

- **WHEN** the play mode is sequential and the last track in the list finishes
- **THEN** playback stops and the state changes to completed

### Requirement: Shuffle playback mode

The system SHALL support a shuffle play mode where tracks play in random order.

#### Scenario: Shuffle mode randomizes order

- **WHEN** the play mode is shuffle and the current track finishes
- **THEN** a randomly selected track from the playlist starts playing, and no track repeats until all tracks have been played

### Requirement: Repeat-one playback mode

The system SHALL support a repeat-one mode where the current track loops indefinitely.

#### Scenario: Repeat-one loops current track

- **WHEN** the play mode is repeat-one and the current track finishes
- **THEN** the same track restarts from the beginning

### Requirement: Repeat-all playback mode

The system SHALL support a repeat-all mode where the playlist loops indefinitely.

#### Scenario: Repeat-all loops playlist

- **WHEN** the play mode is repeat-all and the last track finishes
- **THEN** the first track in the list starts playing

### Requirement: Mode cycling UI

The system SHALL allow the user to cycle through play modes by tapping a single mode button.

#### Scenario: Cycle through modes

- **WHEN** the user taps the play mode button
- **THEN** the mode cycles in the order: Sequential → Shuffle → Repeat-One → Repeat-All → Sequential

### Requirement: Mode persistence within session

The system SHALL maintain the current play mode for the duration of the app session.

#### Scenario: Mode persists across page navigation

- **WHEN** the user sets a play mode and navigates between pages
- **THEN** the play mode remains unchanged
