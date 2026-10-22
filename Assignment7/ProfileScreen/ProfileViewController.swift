import UIKit

// Storyboard only: this class just fills the outlets with data.
// No frames, no constraints, no anchors here.
class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var postsValueLabel: UILabel!
    @IBOutlet weak var followersValueLabel: UILabel!
    @IBOutlet weak var followingValueLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!

    private let profile = Profile.sample
    private var isFollowing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        fill(with: profile)
    }

    private func fill(with profile: Profile) {
        avatarImageView.image = UIImage(named: profile.avatarImageName)
        nameLabel.text = profile.name
        handleLabel.text = profile.handle
        postsValueLabel.text = format(profile.posts)
        followersValueLabel.text = format(profile.followers + (isFollowing ? 1 : 0))
        followingValueLabel.text = format(profile.following)
        aboutLabel.text = profile.about
        followButton.setTitle(isFollowing ? "Following" : "Follow", for: .normal)
    }

    private func format(_ number: Int) -> String {
        switch number {
        case 1_000_000...:
            return String(format: "%gM", (Double(number) / 100_000).rounded() / 10)
        case 1_000...:
            return String(format: "%gK", (Double(number) / 100).rounded() / 10)
        default:
            return "\(number)"
        }
    }

    @IBAction func followTapped(_ sender: UIButton) {
        isFollowing.toggle()
        fill(with: profile)
    }

    @IBAction func messageTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Message", message: "Chat with \(profile.name) is coming soon.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
