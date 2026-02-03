@preconcurrency import AVFoundation
import Combine

/// Manages all game audio using AVAudioEngine
/// Provides one-shot SFX, looping ambient, and volume control
@MainActor
final class AudioSystem {

    // MARK: - Audio Engine

    private let audioEngine = AVAudioEngine()
    private let mixer = AVAudioMixerNode()

    // MARK: - Audio Players

    /// Pool of players for one-shot SFX
    private var sfxPlayers: [AVAudioPlayerNode] = []
    private var availableSfxPlayers: [AVAudioPlayerNode] = []
    private let sfxPoolSize = 16

    /// Dedicated player for ambient loops
    private var ambientPlayer: AVAudioPlayerNode?
    private var currentAmbientBuffer: AVAudioPCMBuffer?

    // MARK: - Audio Buffers (Pre-loaded)

    private var buffers: [SoundEffect: AVAudioPCMBuffer] = [:]

    // MARK: - Volume Control

    var masterVolume: Float = 1.0 {
        didSet { mixer.outputVolume = masterVolume }
    }

    var sfxVolume: Float = 1.0
    var ambientVolume: Float = 0.5 {
        didSet { ambientPlayer?.volume = ambientVolume }
    }

    // MARK: - State

    private var isInitialized = false
    private var isAmbientPlaying = false

    // MARK: - Sound Effects Enum

    enum SoundEffect: String, CaseIterable {
        // Weapon sounds
        case autocannonFire = "autocannon_fire"
        case rocketFire = "rocket_fire"
        case heavyGunFire = "heavy_fire"
        case empBurst = "emp_burst"

        // Impact sounds
        case impactSmall = "impact_small"
        case impactLarge = "impact_large"
        case explosion = "explosion"

        // UI sounds
        case uiClick = "ui_click"
        case uiConfirm = "ui_confirm"

        // Ambient
        case ambientCity = "ambient_city"
        case ambientEngine = "ambient_engine"

        var isAmbient: Bool {
            switch self {
            case .ambientCity, .ambientEngine:
                return true
            default:
                return false
            }
        }
    }

    // MARK: - Initialization

    init() {
        // Setup happens in start() to avoid blocking init
    }

    /// Initializes the audio engine and loads sounds
    func start() {
        guard !isInitialized else { return }

        do {
            // Configure audio session
            try configureAudioSession()

            // Setup engine graph
            setupAudioGraph()

            // Create SFX player pool
            createSfxPlayerPool()

            // Create ambient player
            createAmbientPlayer()

            // Generate placeholder sounds (real assets would be loaded here)
            generatePlaceholderSounds()

            // Start the engine
            try audioEngine.start()

            isInitialized = true
            print("[AudioSystem] Initialized successfully")
        } catch {
            print("[AudioSystem] Failed to initialize: \(error)")
        }
    }

    /// Stops the audio engine
    func stop() {
        audioEngine.stop()
        isInitialized = false
    }

    // MARK: - Audio Session

    private func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try session.setActive(true)
    }

    // MARK: - Engine Setup

    private func setupAudioGraph() {
        // Add mixer to engine
        audioEngine.attach(mixer)

        // Connect mixer to output
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        audioEngine.connect(mixer, to: outputNode, format: format)
    }

    private func createSfxPlayerPool() {
        let format = audioEngine.outputNode.inputFormat(forBus: 0)

        for _ in 0..<sfxPoolSize {
            let player = AVAudioPlayerNode()
            audioEngine.attach(player)
            audioEngine.connect(player, to: mixer, format: format)
            sfxPlayers.append(player)
            availableSfxPlayers.append(player)
        }
    }

    private func createAmbientPlayer() {
        let format = audioEngine.outputNode.inputFormat(forBus: 0)

        let player = AVAudioPlayerNode()
        audioEngine.attach(player)
        audioEngine.connect(player, to: mixer, format: format)
        player.volume = ambientVolume
        ambientPlayer = player
    }

    // MARK: - Sound Generation (Placeholder)

    /// Generates simple synthesized sounds as placeholders
    /// In production, these would be loaded from audio files
    private func generatePlaceholderSounds() {
        // Use the output format to ensure compatibility
        let outputFormat = audioEngine.outputNode.inputFormat(forBus: 0)
        let sampleRate = outputFormat.sampleRate > 0 ? outputFormat.sampleRate : 44100
        let channels = outputFormat.channelCount > 0 ? outputFormat.channelCount : 2

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: channels) else {
            print("[AudioSystem] Failed to create audio format")
            return
        }

        // Generate each sound effect
        for effect in SoundEffect.allCases {
            if let buffer = generateSound(for: effect, format: format) {
                buffers[effect] = buffer
            }
        }
    }

    private func generateSound(for effect: SoundEffect, format: AVAudioFormat) -> AVAudioPCMBuffer? {
        let sampleRate = format.sampleRate
        let duration: Double
        let frequency: Double
        let type: WaveType

        switch effect {
        case .autocannonFire:
            duration = 0.08
            frequency = 150
            type = .noise
        case .rocketFire:
            duration = 0.3
            frequency = 80
            type = .swoosh
        case .heavyGunFire:
            duration = 0.15
            frequency = 100
            type = .noise
        case .empBurst:
            duration = 0.5
            frequency = 200
            type = .sweep
        case .impactSmall:
            duration = 0.1
            frequency = 300
            type = .noise
        case .impactLarge:
            duration = 0.2
            frequency = 150
            type = .noise
        case .explosion:
            duration = 0.4
            frequency = 60
            type = .noise
        case .uiClick:
            duration = 0.05
            frequency = 800
            type = .sine
        case .uiConfirm:
            duration = 0.1
            frequency = 1000
            type = .sine
        case .ambientCity:
            duration = 4.0
            frequency = 100
            type = .ambientNoise
        case .ambientEngine:
            duration = 2.0
            frequency = 80
            type = .ambientNoise
        }

        let frameCount = AVAudioFrameCount(duration * sampleRate)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            return nil
        }
        buffer.frameLength = frameCount

        guard let floatData = buffer.floatChannelData else {
            return nil
        }

        // Generate waveform for all channels
        let channelCount = Int(format.channelCount)
        for channel in 0..<channelCount {
            generateWaveform(into: floatData[channel], frameCount: Int(frameCount), sampleRate: sampleRate, frequency: frequency, type: type)
        }

        return buffer
    }

    private enum WaveType {
        case sine
        case noise
        case swoosh
        case sweep
        case ambientNoise
    }

    private func generateWaveform(into buffer: UnsafeMutablePointer<Float>, frameCount: Int, sampleRate: Double, frequency: Double, type: WaveType) {
        for i in 0..<frameCount {
            let t = Double(i) / sampleRate
            let progress = Double(i) / Double(frameCount)
            let envelope = (1.0 - progress) * (1.0 - progress) // Decay envelope

            var sample: Double

            switch type {
            case .sine:
                sample = sin(2.0 * .pi * frequency * t) * envelope
            case .noise:
                sample = (Double.random(in: -1...1)) * envelope
            case .swoosh:
                let freqSweep = frequency * (1.0 + progress * 2.0)
                sample = sin(2.0 * .pi * freqSweep * t) * envelope * 0.5
                sample += Double.random(in: -0.3...0.3) * envelope
            case .sweep:
                let freqSweep = frequency * (2.0 - progress)
                sample = sin(2.0 * .pi * freqSweep * t) * envelope
            case .ambientNoise:
                // Low frequency filtered noise
                let noise = Double.random(in: -1...1)
                let lowFreq = sin(2.0 * .pi * frequency * t * 0.1) * 0.3
                sample = (noise * 0.1 + lowFreq) * 0.3
            }

            buffer[i] = Float(sample * 0.5) // Reduce overall volume
        }
    }

    // MARK: - Playback

    /// Plays a one-shot sound effect
    func play(_ effect: SoundEffect) {
        guard isInitialized else { return }
        guard let buffer = buffers[effect] else { return }
        guard !availableSfxPlayers.isEmpty else { return }

        let player = availableSfxPlayers.removeLast()

        // Schedule buffer and return player to pool when done
        player.scheduleBuffer(buffer, at: nil, options: []) { [weak self, player] in
            Task { @MainActor [weak self] in
                self?.availableSfxPlayers.append(player)
            }
        }

        player.volume = sfxVolume
        player.play()
    }

    /// Plays weapon fire sound for the given weapon type
    func playWeaponFire(_ weapon: WeaponType) {
        switch weapon {
        case .autocannon:
            play(.autocannonFire)
        case .rockets:
            play(.rocketFire)
        case .heavyGun:
            play(.heavyGunFire)
        case .emp:
            play(.empBurst)
        }
    }

    /// Plays impact sound based on damage
    func playImpact(large: Bool = false) {
        play(large ? .impactLarge : .impactSmall)
    }

    /// Plays explosion sound
    func playExplosion() {
        play(.explosion)
    }

    // MARK: - Ambient Audio

    /// Starts looping ambient audio
    func startAmbient(_ effect: SoundEffect) {
        guard isInitialized else { return }
        guard effect.isAmbient else { return }
        guard let buffer = buffers[effect] else { return }
        guard let player = ambientPlayer else { return }

        // Stop current ambient if playing
        if isAmbientPlaying {
            player.stop()
        }

        // Schedule looping buffer
        currentAmbientBuffer = buffer
        player.scheduleBuffer(buffer, at: nil, options: .loops)
        player.play()
        isAmbientPlaying = true
    }

    /// Stops ambient audio
    func stopAmbient() {
        ambientPlayer?.stop()
        isAmbientPlaying = false
    }

    // MARK: - Volume Presets

    func setVolumePreset(_ preset: VolumePreset) {
        switch preset {
        case .full:
            masterVolume = 1.0
            sfxVolume = 1.0
            ambientVolume = 0.5
        case .reduced:
            masterVolume = 0.7
            sfxVolume = 0.8
            ambientVolume = 0.3
        case .sfxOnly:
            masterVolume = 1.0
            sfxVolume = 1.0
            ambientVolume = 0.0
        case .muted:
            masterVolume = 0.0
        }
    }

    enum VolumePreset {
        case full
        case reduced
        case sfxOnly
        case muted
    }
}
