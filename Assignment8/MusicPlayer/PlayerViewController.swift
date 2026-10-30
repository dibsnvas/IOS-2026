import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    // State lives in one place: which track and whether we are playing.
    private let tracks = TrackLibrary.tracks
    private var currentIndex = 0
    private var isPlaying = false

    // Stored property, so the player lives as long as the screen.
    private var player: AVAudioPlayer?

    private var currentTrack: Track { tracks[currentIndex] }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAudioSession()
        loadCurrentTrack()
        updateUI()
    }

    // MARK: - Actions

    @IBAction func playPauseTapped(_ sender: UIButton) {
        if isPlaying {
            player?.pause()
            isPlaying = false
        } else {
            if player == nil { loadCurrentTrack() }
            isPlaying = player?.play() ?? false
        }
        updateUI()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        switchTrack(by: 1)
    }

    @IBAction func previousTapped(_ sender: UIButton) {
        switchTrack(by: -1)
    }

    // MARK: - Playback

    private func switchTrack(by step: Int) {
        let wasPlaying = isPlaying
        // Wrap around: next on the last goes to the first, previous on the first goes to the last.
        currentIndex = (currentIndex + step + tracks.count) % tracks.count
        loadCurrentTrack()
        if wasPlaying {
            isPlaying = player?.play() ?? false
        }
        updateUI()
    }

    private func loadCurrentTrack() {
        player?.stop()
        player = nil
        isPlaying = false

        guard let url = TrackLibrary.url(for: currentTrack) else {
            print("⚠️ Audio file \(currentTrack.fileName) (.m4a / .mp3) is not in the app bundle")
            return
        }
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.delegate = self
            newPlayer.prepareToPlay()
            player = newPlayer
        } catch {
            print("⚠️ Could not open \(url.lastPathComponent): \(error.localizedDescription)")
        }
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("⚠️ Audio session error: \(error.localizedDescription)")
        }
    }

    // MARK: - UI

    // Refresh the whole screen from the state after every tap.
    private func updateUI() {
        coverImageView.image = UIImage(named: currentTrack.coverImageName) ?? UIImage(named: "launchLogo")
        titleLabel.text = currentTrack.title
        artistLabel.text = currentTrack.artist
        let symbol = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: symbol), for: .normal)
    }
}

// MARK: - AVAudioPlayerDelegate

extension PlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Autoplay: when a track ends, the next one starts.
        isPlaying = true
        switchTrack(by: 1)
    }
}
