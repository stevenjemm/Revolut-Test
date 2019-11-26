//
//  CurrencyTableViewCell.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 15/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    var alreadyExists: Bool! {
        didSet {
            backgroundColor = alreadyExists ? .secondarySystemBackground : .systemBackground
            shortnameLabel.textColor = alreadyExists ? .tertiaryLabel : .secondaryLabel
            longnameLabel.textColor = alreadyExists ? .secondaryLabel : .label
            self.isUserInteractionEnabled = !alreadyExists
            alpha = alreadyExists ? 0.7 : 1.0
        }
    }
    
    var currency: Currency? {
        didSet {
            shortnameLabel.text = currency?.shortCode
            longnameLabel.text = currency?.name
            
            if let imageName = currency?.imageName, let image = UIImage(named: imageName) {
                countryImageView.image = image
            } else {
                countryImageView.image = ImageData.getImage(for: .flagPlaceholder)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)

        accessoryType = selected ? .checkmark : .none
        backgroundColor = selected ? UIColor.secondarySystemBackground : UIColor.systemBackground
        shortnameLabel.textColor = selected ? .tertiaryLabel : .secondaryLabel
        longnameLabel.textColor = selected ? .secondaryLabel : .label
    }
    
    // MARK: - Outlets
    let countryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    let shortnameLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyle.getFont(for: .body)
        label.textColor = .secondaryLabel
        label.text = "eur".uppercased()
        label.textAlignment = .center
        return label
    }()
    
    let longnameLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyle.getFont(for: .body)
        label.textColor = .label
        label.text = "europe".capitalized
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [self.countryImageView,
                                                    self.shortnameLabel,
                                                    self.longnameLabel])
        hStack.alignment = .center
        hStack.spacing = 16
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    // MARK: - Initialiser
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    func setupUI() {
        selectionStyle = .none
        setupContentConstraints()
        
    }
    
    fileprivate func setupContentConstraints() {
        self.addSubview(contentStackView)
        contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        
//        countryImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        shortnameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countryImageView.image = nil
        shortnameLabel.text = ""
        longnameLabel.text = ""
        
    }
}
