//
//  RegisterViewController.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 06.03.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {

    let spinner = JGProgressHUD(style: .dark)
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isUserInteractionEnabled = true
        return scroll
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        image.tintColor = .gray
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 75
        return image
    }()
    
    let firstNameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.placeholder = "First Name"
        return field
    }()
    
    let lastNameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.placeholder = "Last Name"
        return field
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
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector (registerButtonTapped), for: .touchUpInside)
        
        return button
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .systemBackground
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangedProfilePic))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(gesture)
        
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

extension RegisterViewController {
    
    func setupLayout() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
            UIEdgeInsets(top: 50, left: 30, bottom: 0, right: 30))
        }
        
        scrollView.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView.snp.top)
            make.width.height.equalTo(150)
        }
        
        scrollView.addSubview(firstNameField)
        firstNameField.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(39)
            make.top.equalTo(profileImage.snp.bottom).offset(15)
        }
        
        scrollView.addSubview(lastNameField)
        lastNameField.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(39)
            make.top.equalTo(firstNameField.snp.bottom).offset(15)
        }
        
        scrollView.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(39)
            make.top.equalTo(lastNameField.snp.bottom).offset(15)
        }
        
        scrollView.addSubview(passwordField)
        passwordField.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(39)
            make.top.equalTo(emailField.snp.bottom).offset(15)
        }
        
        scrollView.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(39)
            make.top.equalTo(passwordField.snp.bottom).offset(15)
        }
        
        
    }
}

extension RegisterViewController {
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //field validation
    @objc private func registerButtonTapped() {
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty, !password.isEmpty,
              !firstName.isEmpty, !lastName.isEmpty
        else {
            alertUser()
            return
        }
        
        spinner.show(in: view)
        
        //Firebase authentication
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            // bind that optional with guard let, ensure that we capture weakly retained reference of self
            // if we don't include this, just a weak self, funcitonally code woll work, but you wil have a memory leak
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else{
                // user already exists
                strongSelf.alertUser(message: "Looks like the a user with this email already exists")
                return
            }
    
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            // we wanna make sure that error doesn't occur
            guard authResult != nil, error == nil else {
                print("Couldn't create a User")
                return
            }
            
            //once the user is created call dbManager
            DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
            
            //we also need to set dismiss here, in case the user succesfully registers
            strongSelf.navigationController?.dismiss(animated: true)
        }
    }
        
}
    
    func alertUser(message: String = "Plese enter all information") {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated:  true)
    }
    
    @objc func didTapChangedProfilePic() {
        presentPhotoActionSheet()
    }
}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile picture",
                                       message: "Please chose a profile picture from your gallery.",
                                       preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Choose photo", style: .default,
                                            handler: { [weak self] _ in
                                                            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated:  true)
    }
    
    //the info - grab the image from inside of the dictionary imagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        //infokey is an enum
        //editedImage is used to accept only cropped image, it's beneficial to use bc allows to use only one size
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        //needed to unwrap this bc to be a image and non-optional, cast this as uiimage, lets us to assign profiltImage to the selected one
        self.profileImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
