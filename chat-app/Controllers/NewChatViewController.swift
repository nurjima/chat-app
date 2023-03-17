//
//  NewChatViewController.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 06.03.2023.
//


import UIKit
import JGProgressHUD

class NewChatViewController: UIViewController {

    public var completion: (([String:String]) -> (Void))?
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let noResultsLabel = UILabel()
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String:String]]()
    private var results = [[String:String]]()
    private var hasFetched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        setUp()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell" )
        
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.frame.width/4, y: (view.frame.height-200)/2, width: view.frame.width/2, height: 200)
    }
    


}
extension NewChatViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text =  results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //start conversation
        
        let targetUserData = results[indexPath.row]
        
        dismiss(animated: true) { [weak self] in
            self?.completion?(targetUserData)
        }
        
    }
}

extension NewChatViewController{
    func setUp(){
        searchBar.placeholder = "Search for new user"
        tableView.isHidden = true
        
        noResultsLabel.text = "No Results"
        noResultsLabel.textAlignment = .center
        noResultsLabel.textColor = .black
        noResultsLabel.font = .systemFont(ofSize: 20, weight: .medium)
        noResultsLabel.isHidden = true
    }
    
    @objc func dismissSelf(){
        dismiss(animated: true)
    }
}

extension  NewChatViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            return
        }
        
        searchBar.resignFirstResponder()
        results.removeAll()
        
        spinner.show(in: view)
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String){
        if hasFetched{
            filterUsers(with: query)
        } else {
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                    switch result{
                    case .success(let usersCollection):
                        self?.hasFetched = true
                        self?.users = usersCollection
                        self?.filterUsers(with: query)
                    case .failure(let error):
                        print("Failed to get users: \(error)")
                    }
            })
        }
    }

    func filterUsers(with term: String){
        guard hasFetched else {
            return
        }
        
        self.spinner.dismiss(animated: true)
        
        let results: [[String:String]] = self.users.filter {
            guard let name = $0["name"]?.lowercased() else{
                return false
            }
            
            return name.hasPrefix(term.lowercased())
        }
        
        self.results = results
        
        updateUI()
        
    }
    
    func  updateUI(){
        if results.isEmpty {
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        }
        else {
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
