//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Valerian   on 21/11/2020.
//

import UIKit

class NewConversationViewController: UIViewController {
    
<<<<<<< HEAD
=======
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    private var hasFetched = false
    
>>>>>>> parent of 9150cf3... sending iMessage
    private var searchBar : UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search for users....."
        return searchbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    private var tableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        return table
    }()
    
<<<<<<< HEAD
    private var noConversationLabel: UILabel = {
        let label = UILabel()
        label.text = "no conversation"
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
=======
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // start conversation
    }
>>>>>>> parent of 9150cf3... sending iMessage
}

extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}
