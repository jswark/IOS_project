
import UIKit
import CoreData

class FishingTableViewController: UITableViewController {
  
  var statusList: [FishingsData]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    statusList = FishingsData.badgesEarned(runs: getRuns())
  }
  
  private func getRuns() -> [Fishing] {
    let fetchRequest: NSFetchRequest<Fishing> = Fishing.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Fishing.timestamp), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    do {
      return try CoreDataStack.context.fetch(fetchRequest)
    } catch {
      return []
    }
  }
}

// MARK: - Table View Data Source

extension FishingTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return getRuns().count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: FishingsCell = tableView.dequeueReusableCell(for: indexPath)
    cell.data = statusList[indexPath.row]
    return cell
  }
}

// MARK: - Navigation

extension FishingTableViewController: SegueHandlerType {
  enum SegueIdentifier: String {
    case details = "DataFishingDetailsViewController"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segueIdentifier(for: segue) {
    case .details:
      let destination = segue.destination as! DataFishingDetailsViewController
      let indexPath = tableView.indexPathForSelectedRow!
      destination.status = statusList[indexPath.row]
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    guard let segue = SegueIdentifier(rawValue: identifier) else { return false }
    switch segue {
    case .details:
      guard let cell = sender as? UITableViewCell else { return false }
      return cell.accessoryType == .disclosureIndicator
    }
  }
}
