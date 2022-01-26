
//  GitFind
//
//  Created by Артем Калинкин on 25.09.2021.
//

import UIKit
import Combine

class ViewController: UITableViewController, UISearchResultsUpdating {
  
  var client = Client()
  var tableViewRepositories = [Repository]()
  var viewError: Error?
  var currentPage = 1
  var isLoading = false
  var subscriber: AnyCancellable?
  
  let searchController = UISearchController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "GitFind"
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TableViewCell = tableView.dequeueReusableCell(for: indexPath)
    cell.fill(name: tableViewRepositories[indexPath.row].name, amountStars: tableViewRepositories[indexPath.row].starsCount)
    return cell
    
    // error cell
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastElement = tableViewRepositories.count - 1
    if indexPath.row == lastElement && !isLoading {
      if let text = searchController.searchBar.text {
        currentPage += 1
        isLoading = true
        
        let oldCount = self.tableViewRepositories.count
        
        subscriber = client.fetch(query: text, page: currentPage).sink(receiveCompletion: {_ in}, receiveValue:  {
          repositories in
          self.tableViewRepositories.append(contentsOf: repositories.repositories)
          
          self.isLoading = false
          
          DispatchQueue.main.async { [weak self] in
            let indexPathes = (oldCount ..< (oldCount + repositories.repositories.count)).map {index in
              IndexPath(row: index, section: 0)
            }
            self?.tableView.insertRows(at: indexPathes, with: .automatic)
          }
        })
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableViewRepositories.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let wc = storyboard?.instantiateViewController(withIdentifier: "Web") as? WebViewController {
      wc.url = URL(string:  "https://github.com/\(tableViewRepositories[indexPath.row].name)")
      navigationController?.pushViewController(wc, animated: true)
    }
  }

  func updateSearchResults(for searchController: UISearchController) {
    subscriber = NotificationCenter.default
      .publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
      .map({($0.object as? UISearchTextField)?.text})
      .receive(on: RunLoop.main, options: nil)
      .sink { str in
        if let text = str {
          self.currentPage = 1
          guard !self.isLoading else { return }
          self.isLoading = true
          self.client.fetchRepositories(query: text, page: self.currentPage) { [weak self] result in
            switch result {
            case .success(let repositories):
              self?.tableViewRepositories = repositories.repositories
              DispatchQueue.main.async {
                self?.tableView.reloadData()
              }
            case .failure(let error):
              print(error)
            }
            self?.isLoading = false
          }
        }
      }
  }
}
