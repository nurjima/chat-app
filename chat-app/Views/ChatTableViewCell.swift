//
//  ChatTableViewCell.swift
//  chat-app
//
//  Created by Nurzhamal Shaliyeva on 13.03.2023.
//

import UIKit
import SnapKit

class ChatTableViewCell: UITableViewCell {
    
    let userImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
        image.image = UIImage(systemName: "person.bust.fill")
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
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func configure(with model: String) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatTableViewCell {
    func setupLayout() {
        contentView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(userImageView.snp.right).inset(10)
            make.height.equalToSuperview().offset(20/2)
            make.width.equalToSuperview().offset(20)
        }
        contentView.addSubview(userMessageLabel)
        userMessageLabel.snp.makeConstraints { make in
            make.left.equalTo(userNameLabel.snp.right).inset(10)
            make.height.equalToSuperview().offset(20/2)
            make.width.equalToSuperview().offset(20)
        }
    }
}
