//
//  ProfileViewController.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 11.03.2023.
//

import UIKit
import SnapKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    let table: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    let data = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        
        table.delegate = self
        table.dataSource = self
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //unhighlight the cell
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                let navControl = UINavigationController(rootViewController: vc)
                navControl.modalPresentationStyle = .fullScreen
                strongSelf.present(navControl, animated: true)
            } catch {
                print("Failed to log out")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        
        present(alert, animated: true )
                        
        
    }
    
    //alert the user to confirm if they want to log out
    
    
}
