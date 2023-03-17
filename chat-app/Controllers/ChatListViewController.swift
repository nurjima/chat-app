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

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMesage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let is_read: Bool
}

class ChatListViewController: UIViewController {
    
    let spinner = JGProgressHUD(style: .dark)
    
    private var conversations = [Conversation]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        
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

        title = "Chats"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLayout()
        fetchChats()
        startListeningForChats()
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
    
    private func startListeningForChats() {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        print("starting chat fetch...")
        
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        
        DatabaseManager.shared.getAllChats(for: safeEmail) { [weak self] result in
            switch result {
            case .success(let conversations):
                print("successfully got conversation models")
                guard !conversations.isEmpty else {
                    return
                }
                self?.conversations = conversations
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
    
            case.failure(let error):
                print("Failed to get chat: \(error)")
            }
        }
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
        
        let vc = ChatViewController(with: email, id: nil)
        vc.isNewchat = true
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as! ChatTableViewCell
        cell.configure(with: model)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = conversations[indexPath.row]

        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
