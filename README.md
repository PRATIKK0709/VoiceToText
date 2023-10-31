# VoiceToText
A project on voice to text along with transcripts.

## Working and explaination

```
import SwiftUI
import Speech
import AVFoundation
```
This ofcourse imports the needful frameworks.

```
@main
struct VoiceToTextApp: App {
    var body: some Scene {
        WindowGroup {
            VoiceToText()
        }
    }
}
```

@main: This attribute indicates that `VoiceToTextApp` is the main entry point for the application. In SwiftUI, the `@main` attribute is used to designate the app's entry point. <br>

struct VoiceToTextApp: App: This defines a struct named `VoiceToTextApp` that conforms to the `App` protocol. The `App` protocol is essential in SwiftUI to create and manage the structure of the application.<br>

var body: some Scene { ... }: In SwiftUI, the `body` property is used to describe the structure of the app. Here, it defines a `Scene`, which is a fundamental concept in SwiftUI for building user interfaces.<br>

WindowGroup { ... }: A `WindowGroup` represents the main application window. It's where the app's user interface is displayed.<br>

VoiceToText(): This line creates an instance of the `VoiceToText` view, which serves as the main content for the app. The `VoiceToText` view is where the user interacts with the voice-to-text functionality and other features of the app.

```
struct VoiceToText: View {
    @State private var isRecording = false
    @State private var recognizedText = ""
    @State private var audioEngine: AVAudioEngine?
    @State private var request: SFSpeechAudioBufferRecognitionRequest?
    @State private var transcripts: [String] = []
    @State private var recognitionTask: SFSpeechRecognitionTask?
```

isRecording: A Boolean state that tracks whether the app is currently recording audio.
recognizedText: A string state that holds the transcribed text.
audioEngine: An optional AVAudioEngine instance that manages audio recording and playback.
request: An optional SFSpeechAudioBufferRecognitionRequest used for speech recognition.
transcripts: An array of strings to store recorded transcripts.
recognitionTask: An optional SFSpeechRecognitionTask used to manage speech recognition.

```
var body: some View {
    NavigationView {
        VStack {
            Spacer() // Push content to the center vertically
```
This code sets up the overall structure of the view. It uses a NavigationView to establish the navigation hierarchy. Inside the NavigationView, a VStack is used to organize the content vertically.

```
            Text(recognizedText)
                .padding()
                .font(.subheadline)
                .multilineTextAlignment(.center)
```
A Text view displays the recognized text, with formatting applied using the padding, font, and multilineTextAlignment modifiers.

```
            recordingButton
                .padding(.bottom, 10)
```
This is a custom view or function (recordingButton) that likely represents the button to start or stop recording audio. It includes padding to create a small gap between it and the following button.

```
            saveTranscriptButton
                .padding(.bottom, 10)
```
Similar to the recording button, this represents a button to save the transcribed text.

```
            NavigationLink(destination: TranscriptListView(transcripts: $transcripts, saveFunction: saveTranscriptsToUserDefaults, loadFunction: loadTranscriptsFromUserDefaults)) {
                Label("Manage Transcripts", systemImage: "list.bullet.rectangle")
                    .buttonStyle(PrimaryButtonStyle(isDisabled: isRecording))
            }
```
A NavigationLink is used to navigate to another screen, likely for managing saved transcripts. It includes a label with an associated system image and a custom button style (PrimaryButtonStyle). The TranscriptListView is presented with access to the transcripts array and functions for saving and loading transcripts.

```
            Spacer() // Push content to the center vertically
        }
        .navigationTitle("Voice to Text")
        .onAppear {
            requestSpeechAuthorization()
            loadTranscriptsFromUserDefaults()
        }
    }
}
```
The Spacer view helps center the content vertically within the VStack. The .navigationTitle modifier sets the navigation bar's title to "Voice to Text." The .onAppear modifier triggers two actions when the view appears: requesting speech recognition authorization and loading transcripts from user defaults.

This VoiceToText view represents the main user interface for the app and provides functionality for recording, transcribing, saving, and managing transcripts. It appears within a navigation structure, making it part of a broader app interface.
