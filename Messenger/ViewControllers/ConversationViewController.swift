//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Valerian   on 18/11/2020.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ConversationViewController: UIViewController {
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
        view.addSubview(tableView)
        view.addSubview(noConversationLabel)
        setUpTableView()
        fetchConversation()
    }
    
    @objc private func didTapComposeButton() {
        let vc = NewConversationViewController()
        vc.completion = { result in
            print(result)
            self.createNewConversation(result: result)
        }
        //            let currentConversations = strongSelf.conversations
        
        //            if let targetConversation = currentConversations.first(where: {
        //                $0.otherUserEmail == DatabaseManager.safeEmail(emailAddress: result.email)
        //            }) {
        //                let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
        //                vc.isNewConversation = false
        //                vc.title = targetConversation.name
        //                vc.navigationItem.largeTitleDisplayMode = .never
        //                strongSelf.navigationController?.pushViewController(vc, animated: true)
        //            }
        //            else {
        //                strongSelf.createNewConversation(result: result)
        //            }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }

    
    private func createNewConversation(result: [String : String]) {
//        let name = result.name
//        let email = DatabaseManager.safeEmail(emailAddress: result.email)

        // check in datbase if conversation with these two users exists
        // if it does, reuse conversation id
        // otherwise use existing code
        guard let name = result["name"], let email = result["email"] else {
            return
        }
        let vc = ChatViewController(with: email, id: "dada")
        vc.isNewConversation = true
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
//        DatabaseManager.shared.conversationExists(iwth: email, completion: { [weak self] result in
//            guard let strongSelf = self else {
//                return
//            }
//            switch result {
//            case .success(let conversationId):
//                let vc = ChatViewController(with: email, id: conversationId)
//                vc.isNewConversation = false
//                vc.title = name
//                vc.navigationItem.largeTitleDisplayMode = .never
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//            case .failure(_):
//                let vc = ChatViewController(with: email, id: nil)
//                vc.isNewConversation = true
//                vc.title = name
//                vc.navigationItem.largeTitleDisplayMode = .never
//                strongSelf.navigationController?.pushViewController(vc, animated: true)
//            }
//        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchConversation() {
        tableView.isHidden = false
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = "Hello"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController(with: "asdasdadasd", id: "dasdasdas")
        vc.title = "Valerian"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
