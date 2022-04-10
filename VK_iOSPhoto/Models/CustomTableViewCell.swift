//
//  CustomTableViewCell.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 06.04.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    lazy private var labelName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Didot-Italic", size: 30)
        return label
    }()
    
    lazy private var imageUser: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textForEachCell(name: String, image: UIImage) {
        self.labelName.text = name
        self.imageUser.image = image
    }
}
extension CustomTableViewCell {
    private func configuration() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(labelName)
        contentView.addSubview(imageUser)
        
        NSLayoutConstraint.activate([
            imageUser.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageUser.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            imageUser.trailingAnchor.constraint(equalTo: labelName.leadingAnchor, constant: -100),
            imageUser.heightAnchor.constraint(equalToConstant: 60),
            imageUser.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5),
            imageUser.widthAnchor.constraint(equalToConstant: 60),
            labelName.centerYAnchor.constraint(equalTo: imageUser.centerYAnchor),
            labelName.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -30),
        ])
    }
}
