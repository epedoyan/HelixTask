//
//  MasterViewController.swift
//  HelixTask
//
//  Created by Codefights on 3/15/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var detailViewController: DetailViewController? = nil
    var newsItems = [NewsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(iPadOrDeviceOrientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NetworkManager.shared.loadNews(completionHandler: { (items) in
            self.activityIndicator.stopAnimating()
            if let newsItems = items {
                self.newsItems = newsItems
                self.tableView.reloadData()
                self.iPadOrDeviceOrientationChanged()
            }
        })
        self.navigationItem.title = "News"
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    func iPadOrDeviceOrientationChanged() {
        if !(splitViewController!.isCollapsed) && tableView.indexPathForSelectedRow == nil && tableView.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
            performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.newsItem = newsItems[indexPath.row]
                controller.selectedCellRow = indexPath.row
              
                if willUpdateUserDefaultsWith(indexPath) {
                    let cell = tableView.cellForRow(at: indexPath) as! NewsCell
                    cell.backgroundColor = UIColor(red: 196.0/255.0, green: 239.0/255.0, blue: 240.0/255.0, alpha: 1.0)
                }
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Private functions

    private func willUpdateUserDefaultsWith(_ indexPath: IndexPath) -> Bool {
        let defaults = UserDefaults.standard
        var selectedRowsArray = (defaults.object(forKey: "selectedRows") as? [Int]) ?? [Int]()
        if !selectedRowsArray.contains(indexPath.row) {
            selectedRowsArray.append(indexPath.row)
            defaults.set(selectedRowsArray, forKey: "selectedRows")
            return true
        }
        return false
    }
    
    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.setNewsItem(newsItems[indexPath.row], forRow: indexPath.row)
        if let selectedRowsArray = UserDefaults.standard.array(forKey: "selectedRows") as? [Int] {
            if selectedRowsArray.contains(indexPath.row) {
                cell.backgroundColor = UIColor(red: 196.0/255.0, green: 239.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            }
        }
        return cell
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

