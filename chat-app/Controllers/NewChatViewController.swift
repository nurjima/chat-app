//
//  NewChatViewController.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 06.03.2023.
//

import UIKit
import JGProgressHUD

class NewChatViewController: UIViewController {
    
    let spinner = JGProgressHUD(style: .dark)
    
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search for users..."
        return search
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let noResults: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No results"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
    }

}

extension NewChatViewController {
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}

extension NewChatViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
