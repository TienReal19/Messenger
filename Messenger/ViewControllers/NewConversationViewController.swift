//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Valerian   on 21/11/2020.
//

import UIKit

class NewConversationViewController: UIViewController {
    
    public var completion: (([String : String]) -> (Void))?
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    private var hasFetched = false
    
    private var searchBar : UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search for users....."
        return searchbar
    }()
    
    private var tableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        return table
    }()
    
    private var noConversationLabel: UILabel = {
        let label = UILabel()
        label.text = "no conversation"
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(noConversationLabel)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noConversationLabel.frame = CGRect(x: view.width/4,
                                           y: (view.heigh - 200)/2  ,
                                           width: view.width/2,
                                           height: 200)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start conversation
        let targetUserData = results[indexPath.row]

        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })
    }
}

//MARK: - UISearchBarDelegate
extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()

        results.removeAll()
        searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        // check if array has firebase results
        if hasFetched {
            // if it does: filter
            filterUsers(with: query)
        }
        else {
            // if not, fetch then filter
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get usres: \(error)")
                }
            })
        }
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else {
            return
        }
        
        let results: [[String : String]] = users.filter({
//            guard let email = $0["email"], email != safeEmail else {
//                return false
//            }
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            noConversationLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noConversationLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
