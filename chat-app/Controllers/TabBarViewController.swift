//
//  TabBarViewController.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 11.03.2023.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .systemIndigo
        tabBar.unselectedItemTintColor = .systemGray
        
        let tabOne = UINavigationController(rootViewController: ChatListViewController())
        let tabTwo = UINavigationController(rootViewController: ProfileViewController())
        
        tabOne.title = "Chats"
        tabTwo.title = "Profile"
        
        self.setViewControllers([tabOne, tabTwo], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["ellipsis.message.fill", "person.crop.square.fill"]
        
        for x in 0...1 {
            items[x].image = UIImage(systemName: images[x])
        }
    }
}
