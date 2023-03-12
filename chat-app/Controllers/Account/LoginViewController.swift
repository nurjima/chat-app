//
//  ViewController.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 01.03.2023.
//

import UIKit
import SnapKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    let spinner = JGProgressHUD(style: .dark)
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.clipsToBounds = true
        return scroll
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "login")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.placeholder = "Email Address"
        return field
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        return field
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        return button
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reigster", style: .done, target: self, action: #selector(didTapRegister))
        
        setupLayout()
    }
    
}

extension LoginViewController {
    
    func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
            UIEdgeInsets(top: 50, left: 30, bottom: 0, right: 30))
        }
        
        scrollView.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(320)
            make.top.equalTo(scrollView.snp.top)
        }
        
        scrollView.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(39)
            make.top.equalTo(profileImage.snp.bottom).offset(20)
        }
        
        scrollView.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(39)
            make.top.equalTo(emailField.snp.bottom).offset(15)
        }
        
        scrollView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(39)
            make.top.equalTo(passwordField.snp.bottom).offset(15)
        }
    }
}

extension LoginViewController {
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //field validation
    @objc func loginButtonTapped() {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            alertUser()
            return
        }
        
        spinner.show(in: view)
        
        //Firebase Login
        //weak self to not cause a retention cycle
        //we can unwrap the weak self, to be strong self
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let result = authResult, error == nil else {
                print("Failed to sign in the User with an email: \(email)")
                return
            }
            
            // and if the user successfully signed in to their account
            let user = result.user
            print("Successfully logged in the User: \(user)")
            strongSelf.navigationController?.dismiss(animated: true)
        }
        
        //once the user succesfully logs in, we need to dismiss this navgiation controller
        //the way we can do that is by calling "Dismiss"
        
        
    }
    
    func alertUser() {
        let alert = UIAlertController(title: "Oops!", message: "Plese enter all information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated:  true)
    }
}
