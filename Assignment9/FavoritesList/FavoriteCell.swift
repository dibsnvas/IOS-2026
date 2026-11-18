import UIKit

// Only outlets + one method that fills the cell. No layout code.
class FavoriteCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!

    // Cells are reused, so every field is reset from the item each time.
    func configure(with item: FavoriteItem) {
        posterImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        for (index, star) in starImageViews.enumerated() {
            star.image = UIImage(systemName: index < item.rating ? "star.fill" : "star")
        }
    }
}
