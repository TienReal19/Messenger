//
//  ConversationViewController.swift
//  Messenger
//
//  Created by Valerian   on 18/11/2020.
//

import Foundation
import UIKit

class ConversationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isLoggedIn = UserDefaults.standard.bool(forKey: "Logged_in")
        if !isLoggedIn {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
}
