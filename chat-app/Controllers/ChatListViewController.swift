//
//  UserListViewController.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 04.03.2023.
//

import UIKit
import FirebaseAuth
import SnapKit
import JGProgressHUD



class ChatListViewController: UIViewController {
    
    let spinner = JGProgressHUD(style: .dark)
    
    let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    let noChats: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Chats"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 27, weight: .medium)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLayout()
        fetchChats()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    func validateAuth() {
        // will handle an appropriate use case for an authentication
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let navControl = UINavigationController(rootViewController: vc)
            navControl.modalPresentationStyle = .fullScreen
            present(navControl, animated: false)
        }
    }
}

extension ChatListViewController {
    func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(noChats)
        noChats.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    func fetchChats() {
        tableView.isHidden = false
    }
    
    @objc func didTapComposeButton() {
        let vc = NewChatViewController()
        vc.completion = { [weak self] result in
            print("\(result)")
            self?.createNewChat(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func createNewChat(result: [String: String]) {
        
        guard let name = result["name"], let email = result["email"] else {
            return
        }
        
        let vc = ChatViewController(with: email)
        vc.isNewchat = true
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World!"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController(with: "klffk@gmial.com")
        vc.title = "Aki Takayashi"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
