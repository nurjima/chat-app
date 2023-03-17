//
//  ChatTableViewCell.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 13.03.2023.
//

import UIKit
import SnapKit


class ChatTableViewCell: UITableViewCell {
    
    static let identifier = "ChatTableViewCell"
    
    let profilePic: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.circle.fill")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 40
        image.layer.masksToBounds = true
        return image
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21)
        return label
    }()
    
    let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatTableViewCell {
    func setupLayout() {
        
        contentView.addSubview(profilePic)
        profilePic.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(profilePic.snp.right).offset(10)
            make.width.equalToSuperview().offset(20)
        }
        contentView.addSubview(userMessageLabel)
        userMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.top).offset(30)
            make.left.equalTo(profilePic.snp.right).offset(10)
            make.width.equalToSuperview().offset(20)
        }
    }
    
    public func configure(with model: Conversation) {
        self.userMessageLabel.text = model.latestMesage.text
        self.userNameLabel.text = model.name
    }
}
