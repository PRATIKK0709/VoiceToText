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

isRecording: A Boolean state that tracks whether the app is currently recording audio.<br>
recognizedText: A string state that holds the transcribed text.<br>
audioEngine: An optional AVAudioEngine instance that manages audio recording and playback.<br>
request: An optional SFSpeechAudioBufferRecognitionRequest used for speech recognition.<br>
transcripts: An array of strings to store recorded transcripts.<br>
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
The Spacer view helps center the content vertically within the VStack. The .navigationTitle modifier sets the navigation bar's title to "Voice to Text." The .onAppear modifier triggers two actions when the view appears: requesting speech recognition authorization and loading transcripts from user defaults.<br>

This VoiceToText view represents the main user interface for the app and provides functionality for recording, transcribing, saving, and managing transcripts. It appears within a navigation structure, making it part of a broader app interface.

```
private var recordingButton: some View {
```
This line defines a private computed property called recordingButton. Computed properties are used to calculate values on the fly, and they can be used within SwiftUI views.

```
    Button(action: {
        isRecording.toggle()
        if isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }) {
```
This part of the code creates a Button view. The button's behavior is defined by the provided closure in the action parameter. When the button is tapped, this closure is executed. In this case, it toggles the isRecording state, which controls whether the app is currently recording audio. If isRecording is true, it calls the startRecording() function, and if it's false, it calls the stopRecording() function.

```
        Label(isRecording ? "Stop Recording" : "Start Recording", systemImage: isRecording ? "stop.circle" : "mic.circle.fill")
```
Within the button, a Label view is used to display text and an associated system image based on the isRecording state. If isRecording is true, the label says "Stop Recording" and displays a stop icon ("stop.circle"). If isRecording is false, it says "Start Recording" and displays a microphone icon ("mic.circle.fill").

```
            .buttonStyle(PrimaryButtonStyle(isDisabled: false))
        }
```

The buttonStyle modifier applies a custom button style called PrimaryButtonStyle to the button. It also sets the isDisabled parameter of the style to false, which means the button is enabled.

In summary, the recordingButton is a SwiftUI view element, represented as a button. When tapped, it toggles between starting and stopping audio recording in the VoiceToText app, and its appearance and behavior change based on the isRecording state
