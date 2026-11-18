import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!

    // Set by the list in prepare(for:sender:).
    var item: FavoriteItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item else { return }
        title = item.title
        imageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description
        for (index, star) in starImageViews.enumerated() {
            star.image = UIImage(systemName: index < item.rating ? "star.fill" : "star")
        }
    }
}
