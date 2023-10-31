# Summary

- VoiceToTextApp is the app's entry point, defining the main view.
- VoiceToText is the primary view. It records and transcribes voice input, allowing users to start/stop recording, save transcripts, and manage saved transcripts.
- It uses @State variables to manage the app's state, such as recording status, recognized text, and saved transcripts.
- It requests speech recognition authorization and sets up the audio engine for recording.
- Users can start and stop recording, with recognized text displayed in a Text view.
- The "Save Transcript" button allows users to save the current transcription.
- The "Manage Transcripts" button links to a separate view (TranscriptListView) for managing saved transcripts.
- TranscriptListView displays saved transcripts, allowing users to delete them.
- The app uses a custom button style (PrimaryButtonStyle) to adjust button appearance and behavior based on the recording state.
- Saved transcripts are stored in UserDefaults, making them persistent.
