import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let items = FavoritesLibrary.items
    private let cellIdentifier = "FavoriteCell"
    private let detailSegueIdentifier = "showDetail"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Deselect the tapped row after coming back from Detail (follows the interactive swipe too).
        guard let selected = tableView.indexPathForSelectedRow else { return }
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.tableView.deselectRow(at: selected, animated: true)
            }, completion: { context in
                if context.isCancelled {
                    self.tableView.selectRow(at: selected, animated: false, scrollPosition: .none)
                }
            })
        } else {
            tableView.deselectRow(at: selected, animated: animated)
        }
    }

    // Only data is passed: the Detail screen fills its own outlets.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == detailSegueIdentifier,
              let detail = segue.destination as? DetailViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        detail.item = items[indexPath.row]
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
}
