//
//  UserListViewController.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 04.03.2023.
//

import UIKit

class ChatListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // userDefaults are used to save some data to disk
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if !isLoggedIn {
            let vc = LoginViewController()
            let navControl = UINavigationController(rootViewController: vc)
            navControl.modalPresentationStyle = .fullScreen
            present(navControl, animated: false)
        }
    }
}

