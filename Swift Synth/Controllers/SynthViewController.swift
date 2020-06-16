
import UIKit

class SynthViewController: UIViewController {
    
    enum Language: Int {
        case swift, objc
    }
    
    private var languageSelected = Language.swift
    
    private lazy var parameterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Frequency: 0 Hz  Amplitude: 0%"
        label.translatesAutoresizingMaskIntoConstraints = false

		return label
    }()
    
    private lazy var isPlayingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var waveformSelectorSegmentedControl: UISegmentedControl = {
        var images = [#imageLiteral(resourceName: "Sine Wave Icon"), #imageLiteral(resourceName: "Triangle Wave Icon"), #imageLiteral(resourceName: "Sawtooth Wave Icon"), #imageLiteral(resourceName: "Square Wave Icon"), #imageLiteral(resourceName: "Noise Wave Icon")]
        images = images.map { $0.resizableImage(withCapInsets: .init(top: 0, left: 10, bottom: 0, right: 10),
                                                resizingMode: .stretch) }
        let segmentedControl = UISegmentedControl(items: images)
        
        segmentedControl.setContentPositionAdjustment(.zero, forSegmentType: .any, barMetrics: .default)
        segmentedControl.addTarget(self, action: #selector(updateOscillatorWaveform), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0

        segmentedControl.selectedSegmentTintColor = .interactiveColor
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		
        return segmentedControl
    }()
    
    private lazy var languageSelectorSegmentedControl: UISegmentedControl = {
        var languages = ["Swift", "Obj-C"]
        let segmentedControl = UISegmentedControl(items: languages)
        
        segmentedControl.setContentPositionAdjustment(.zero, forSegmentType: .any, barMetrics: .default)
        segmentedControl.addTarget(self, action: #selector(updateLanguage), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0

        segmentedControl.selectedSegmentTintColor = .interactiveColor
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

		setUpView()
        setUpSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPlaybackStateTo(true)

		guard let touch = touches.first else { return }
        
		let coord = touch.location(in: view)
        setSynthParametersFrom(coord)
        
        updateIsPlayingLabel()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

		let coord = touch.location(in: view)
        setSynthParametersFrom(coord)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPlaybackStateTo(false)
        parameterLabel.text = "Frequency: 0 Hz  Amplitude: 0%"
        
        updateIsPlayingLabel()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPlaybackStateTo(false)
        parameterLabel.text = "Frequency: 0 Hz  Amplitude: 0%"
    }
    
    // MARK: Selector Functions
    
    @objc private func updateOscillatorWaveform() {
        switch languageSelected {
        case .swift:
            let waveform = Waveform(rawValue: waveformSelectorSegmentedControl.selectedSegmentIndex)!
            switch waveform {
                case .sine:         Synth.shared.setWaveformTo(Oscillator.sine)
                case .triangle:     Synth.shared.setWaveformTo(Oscillator.triangle)
                case .sawtooth:     Synth.shared.setWaveformTo(Oscillator.sawtooth)
                case .square:       Synth.shared.setWaveformTo(Oscillator.square)
                case .whiteNoise:   Synth.shared.setWaveformTo(Oscillator.whiteNoise)
            }
        case .objc:
            let waveform = WaveFormOBJC(rawValue: waveformSelectorSegmentedControl.selectedSegmentIndex)!
            switch waveform {
            case .sine:         SynthOBJC.shared().setWaveformTo(OscillatorOBJC.sine())
            case .triangle:     SynthOBJC.shared().setWaveformTo(OscillatorOBJC.triangle())
            case .sawtooth:     SynthOBJC.shared().setWaveformTo(OscillatorOBJC.sawtooth())
            case .square:       SynthOBJC.shared().setWaveformTo(OscillatorOBJC.square())
            case .whiteNoise:   SynthOBJC.shared().setWaveformTo(OscillatorOBJC.whiteNoise())
            @unknown default: fatalError("Case not handled: \(waveform.rawValue)")
            }
        }
    }
    
    @objc private func updateLanguage() {
        guard let language = Language(rawValue: languageSelectorSegmentedControl.selectedSegmentIndex) else {
            return
        }
        languageSelected = language
        updateOscillatorWaveform()
    }
    
    @objc private func setPlaybackStateTo(_ state: Bool) {
        switch languageSelected {
        case .swift:
            Synth.shared.volume = state ? 0.5 : 0
        case .objc:
            SynthOBJC.shared().volume = state ? 0.5 : 0
        }
    }
    
    private func setUpView() {
        view.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1647058824, blue: 0.1882352941, alpha: 1)
        view.isMultipleTouchEnabled = false
    }
    
    private func setUpSubviews() {
        view.add(waveformSelectorSegmentedControl, parameterLabel, languageSelectorSegmentedControl, isPlayingLabel)
        
        NSLayoutConstraint.activate([
            waveformSelectorSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            waveformSelectorSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            waveformSelectorSegmentedControl.widthAnchor.constraint(equalToConstant: 250),
            
            parameterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            parameterLabel.centerYAnchor.constraint(equalTo: waveformSelectorSegmentedControl.centerYAnchor),
            
            languageSelectorSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            languageSelectorSegmentedControl.topAnchor.constraint(equalTo: waveformSelectorSegmentedControl.bottomAnchor, constant: 10),
            
            isPlayingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            isPlayingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setSynthParametersFrom(_ coord: CGPoint) {
        let amplitudePercent: Int
        let frequencyHertz: Int
        
        switch languageSelected {
        case .swift:
            Oscillator.amplitude = Float((view.bounds.height - coord.y) / view.bounds.height)
            Oscillator.frequency = Float(coord.x / view.bounds.width) * 1014 + 32
            amplitudePercent = Int(Oscillator.amplitude * 100)
            frequencyHertz = Int(Oscillator.frequency)
        case .objc:
            OscillatorOBJC.setAmplitude(Float((view.bounds.height - coord.y) / view.bounds.height))
            OscillatorOBJC.setFrequency(Float(coord.x / view.bounds.width) * 1014 + 32)
            amplitudePercent = Int(OscillatorOBJC.amplitude() * 100)
            frequencyHertz = Int(OscillatorOBJC.frequency())
        }

        parameterLabel.text = "Frequency: \(frequencyHertz) Hz  Amplitude: \(amplitudePercent)%"
    }
    
    private func updateIsPlayingLabel() {
        if case languageSelected = Language.objc {
            isPlayingLabel.text = SynthOBJC.shared().isPlaying() ? "Playing..." : nil
        } else {
            isPlayingLabel.text = nil
        }
    }
}
