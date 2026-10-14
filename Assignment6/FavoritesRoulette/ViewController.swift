import UIKit
import ImageIO

class ViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var spinButton: UIButton!

    private let favorites = Favorite.all
    private var currentIndex: Int?
    private var spinCount = 0

    private let defaultAccent = UIColor(red: 0.902, green: 0.204, blue: 0.263, alpha: 1)
    private let defaultBackground = UIColor(red: 0.067, green: 0.067, blue: 0.086, alpha: 1)
    private let defaultCard = UIColor(red: 0.137, green: 0.133, blue: 0.161, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        styleViews()
        showInitialState()
    }

    @IBAction func spinTapped(_ sender: UIButton) {
        guard let nextIndex = randomIndex(excluding: currentIndex) else { return }
        spinCount += 1
        show(favorites[nextIndex], at: nextIndex)
    }

    private func randomIndex(excluding excluded: Int?) -> Int? {
        var candidates = Array(favorites.indices)
        if let excluded {
            candidates.removeAll { $0 == excluded }
        }
        return candidates.randomElement()
    }

    private func show(_ favorite: Favorite, at index: Int) {
        currentIndex = index
        UIView.transition(with: cardView, duration: 0.35, options: .transitionFlipFromLeft) {
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = UIImage(named: favorite.imageName)
            self.titleLabel.text = favorite.title
            self.descriptionLabel.text = favorite.description
            self.counterLabel.text = "Favorite \(index + 1) of \(self.favorites.count) · spin #\(self.spinCount)"
        }
        spinButton.setTitle("Spin again", for: .normal)
        applyTheme(accent: favorite.accentColor)
    }

    private func showInitialState() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = animatedGIF(named: "spongebob") ?? UIImage(named: "spongebobStill")
        titleLabel.text = "Spin it to see niche taste in movies"
        descriptionLabel.text = "\(favorites.count) movies I love. Tap the button and get a random one."
        counterLabel.text = "\(favorites.count) favorites inside"
        spinButton.setTitle("Let's go", for: .normal)
        applyTheme(accent: nil)
    }

    private func applyTheme(accent: UIColor?) {
        let headerColor = accent ?? defaultAccent
        let buttonColor = accent?.blended(with: .black, fraction: 0.2) ?? defaultAccent
        let backgroundColor = accent?.blended(with: .black, fraction: 0.78) ?? defaultBackground
        let cardColor = accent?.blended(with: defaultCard, fraction: 0.82) ?? defaultCard

        UIView.animate(withDuration: 0.6) {
            self.view.backgroundColor = backgroundColor
            self.cardView.backgroundColor = cardColor
            self.spinButton.backgroundColor = buttonColor
        }
        UIView.transition(with: headerLabel, duration: 0.6, options: .transitionCrossDissolve) {
            self.headerLabel.textColor = headerColor
        }
    }

    private func animatedGIF(named name: String) -> UIImage? {
        guard let asset = NSDataAsset(name: name),
              let source = CGImageSourceCreateWithData(asset.data as CFData, nil) else { return nil }
        var frames: [UIImage] = []
        var duration = 0.0
        for index in 0..<CGImageSourceGetCount(source) {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else { continue }
            frames.append(UIImage(cgImage: cgImage))
            let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any]
            let gif = properties?[kCGImagePropertyGIFDictionary] as? [CFString: Any]
            let delay = gif?[kCGImagePropertyGIFUnclampedDelayTime] as? Double
                ?? gif?[kCGImagePropertyGIFDelayTime] as? Double
                ?? 0.1
            duration += delay
        }
        guard frames.isEmpty == false else { return nil }
        return UIImage.animatedImage(with: frames, duration: duration)
    }

    private func styleViews() {
        cardView.layer.cornerRadius = 28
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowRadius = 18
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        spinButton.layer.cornerRadius = 18
        spinButton.clipsToBounds = true
    }
}

extension UIColor {
    func blended(with other: UIColor, fraction: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        guard getRed(&r1, green: &g1, blue: &b1, alpha: &a1),
              other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }
        let t = min(max(fraction, 0), 1)
        return UIColor(red: r1 + (r2 - r1) * t,
                       green: g1 + (g2 - g1) * t,
                       blue: b1 + (b2 - b1) * t,
                       alpha: a1 + (a2 - a1) * t)
    }
}
