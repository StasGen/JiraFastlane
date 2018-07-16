//
//  UsersViewController.swift
//  GithubUsersBrowser
//
//  Created by Stanislav Kaliberov on 4/2/18.
//  Copyright © 2018 Stanislav Kaliberov. All rights reserved.
//

import UIKit


class UsersViewController: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    var users: [UserPlainModel]!
    var searchText: String = "" {
        didSet {
            users = []
            getRepositories(searchText: searchText)
        }
    }
    var isFetching = false
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        users = []
        tableView.contentInset.bottom = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let cells = tableView.visibleCells.compactMap { $0 as? UserTableViewCell }
        let indexes = tableView.visibleCells.compactMap { tableView.indexPath(for: $0) }
        
        zip(cells, indexes).forEach {
            let rectOfCellInTableView = tableView.rectForRow(at: $0.1)
            let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
            $0.0.configureAppearence(value: rectOfCellInSuperview.origin.y/tableView.bounds.height)
        }
        
        tableView.reloadData()
    }
    
    func getRepositories(searchText: String) {
        guard isFetching == false else { return }
        isFetching = true
        activityIndicator.startAnimating()
        
        let offset = users.count
        
        let firstQueuePage = offset/15 + 1
        
        let group = DispatchGroup()
        var repositoriesDic: [Int : [UserPlainModel]] = [:]
        
        for i in 1...2 {
            getUsersFromApi(searchText: searchText, page: firstQueuePage + i, dispatchGroup: group, completion: { users, error in
                switch (users, error) {
                case (let users, nil) where users != nil:
                    repositoriesDic[i] = users!
                    
                default: ()
                }
            })
        }
        
        group.notify(queue: .global()) {
            var meargedRepositories: [UserPlainModel] = []
            repositoriesDic.sorted(by: { $0.key < $1.key }).forEach{ meargedRepositories.append(contentsOf: $0.value) }
            
            DispatchQueue.main.async {
                self.users.append(contentsOf: meargedRepositories)
                self.tableView.reloadData()
                self.isFetching = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func getUsersFromApi(searchText: String, page: Int, dispatchGroup: DispatchGroup, completion: @escaping ([UserPlainModel]?, Error?)->()) {
        dispatchGroup.enter()
        
        GithubApiLoader.shared.searchUsers(searchText: searchText, pagination: Pagination(page: page, itemsPerPage: 15)) { repositories, error in
            completion(repositories, error)
            dispatchGroup.leave()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserDetailSegue" {
            (segue.destination as? UserViewController)?.user = sender as? UserPlainModel
            (segue.destination as? UserViewController)?.delegate = self
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.configure(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

extension UsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedUser = users[indexPath.row]
        
        performSegue(withIdentifier: "showUserDetailSegue", sender: selectedUser)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 0 {
            getRepositories(searchText: searchText)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cells = tableView.visibleCells.compactMap { $0 as? UserTableViewCell }
        let indexes = tableView.visibleCells.compactMap { tableView.indexPath(for: $0) }
        
        zip(cells, indexes).forEach {
            let rectOfCellInTableView = tableView.rectForRow(at: $0.1)
            let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
            $0.0.configureAppearence(value: rectOfCellInSuperview.origin.y/tableView.bounds.height)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
        (cell as! UserTableViewCell).configureAppearence(value: rectOfCellInSuperview.origin.y/tableView.bounds.height)
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}


extension UsersViewController: UsersViewControllerDelegate {
    
    func userDidViewed(user: UserPlainModel) {
        for (index, _) in users.enumerated() {
            if users[index] == user {
                users[index].viewed = true
                tableView.reloadData()
                continue
            }
        }
    }
}
