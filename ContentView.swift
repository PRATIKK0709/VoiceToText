import SwiftUI
import Speech
import AVFoundation

@main
struct VoiceToTextApp: App {
    var body: some Scene {
        WindowGroup {
            VoiceToText()
        }
    }
}

struct VoiceToText: View {
    @State private var isRecording = false
    @State private var recognizedText = ""
    @State private var audioEngine: AVAudioEngine?
    @State private var request: SFSpeechAudioBufferRecognitionRequest?
    @State private var transcripts: [String] = []
    @State private var recognitionTask: SFSpeechRecognitionTask?

    var body: some View {
        NavigationView {
            VStack {
                Spacer() // Push content to the center vertically
                Text(recognizedText)
                    .padding()
                    .font(.subheadline)
                    .multilineTextAlignment(.center)

                recordingButton
                    .padding(.bottom, 10) // Add a small gap between recordingButton and saveTranscriptButton

                saveTranscriptButton
                    .padding(.bottom, 10) // Add a small gap between saveTranscriptButton and NavigationLink

                NavigationLink(destination: TranscriptListView(transcripts: $transcripts, saveFunction: saveTranscriptsToUserDefaults, loadFunction: loadTranscriptsFromUserDefaults)) {
                    Label("Manage Transcripts", systemImage: "list.bullet.rectangle")
                        .buttonStyle(PrimaryButtonStyle(isDisabled: isRecording))
                }
                Spacer() // Push content to the center vertically
            }
            .navigationTitle("Voice to Text")
            .onAppear {
                requestSpeechAuthorization()
                loadTranscriptsFromUserDefaults()
            }
        }
    }

    private var recordingButton: some View {
        Button(action: {
            isRecording.toggle()
            if isRecording {
                startRecording()
            } else {
                stopRecording()
            }
        }) {
            Label(isRecording ? "Stop Recording" : "Start Recording", systemImage: isRecording ? "stop.circle" : "mic.circle.fill")
                .buttonStyle(PrimaryButtonStyle(isDisabled: false))
        }
    }

    private var saveTranscriptButton: some View {
        Button(action: {
            saveTranscript()
        }) {
            Label("Save Transcript", systemImage: "square.and.arrow.up")
                .buttonStyle(PrimaryButtonStyle(isDisabled: isRecording))
        }
    }

    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            if status == .authorized {
                audioEngine = AVAudioEngine()
                request = SFSpeechAudioBufferRecognitionRequest()
            }
        }
    }

    private func startRecording() {
        if recognitionTask == nil {
            do {
                audioEngine = AVAudioEngine()
                request = SFSpeechAudioBufferRecognitionRequest()
                let node = audioEngine?.inputNode
                let recordingFormat = node?.outputFormat(forBus: 0)

                node?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                    request?.append(buffer)
                }

                audioEngine?.prepare()
                try audioEngine?.start()

                recognitionTask = SFSpeechRecognizer()?.recognitionTask(with: request!) { result, error in
                    if let result = result {
                        recognizedText = result.bestTranscription.formattedString
                    }
                    if error != nil || result?.isFinal == true {
                        stopRecording()
                    }
                }
            } catch {
                print("Error starting recording: \(error)")
            }
        }
    }

    private func stopRecording() {
        audioEngine?.stop()
        request?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil // Set it to nil to allow a new recognition task
    }

    private func saveTranscript() {
        if !recognizedText.isEmpty && !isRecording {
            transcripts.append(recognizedText)
            recognizedText = ""
            saveTranscriptsToUserDefaults()
        }
    }

    private func saveTranscriptsToUserDefaults() {
        UserDefaults.standard.set(transcripts, forKey: "TranscriptsKey")
    }

    private func loadTranscriptsFromUserDefaults() {
        if let loadedTranscripts = UserDefaults.standard.stringArray(forKey: "TranscriptsKey") {
            transcripts = loadedTranscripts
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .opacity(isDisabled ? 0.5 : 1.0)
            .disabled(isDisabled)
    }
}


struct TranscriptListView: View {
    @Binding var transcripts: [String]
    var saveFunction: () -> Void
    var loadFunction: () -> Void

    var body: some View {
        NavigationView {
            List {
                ForEach(transcripts, id: \.self) { transcript in
                    Text(transcript)
                }
                .onDelete(perform: deleteTranscript)
            }
            .navigationTitle("Transcripts")
            .toolbar {
                EditButton()
            }
        }
    }

    private func deleteTranscript(offset: IndexSet) {
        transcripts.remove(atOffsets: offset)
        saveFunction() 
    }
}

struct VoiceToText_Previews: PreviewProvider {
    static var previews: some View {
        VoiceToText()
    }
}
