//
//  AddCurrencyPairCell.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 19/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

class AddCurrencyPairCell: UITableViewCell {
    
    
    // MARK: - Properties
    
    static let cellId = "cellId"
    
    var rate: Double? {
        didSet {
            rateLabel.text = rate!.isZero ? "- - -" : "\(rate!)"
        }
    }
    
    var currencyPair: CurrencyPair! {
        didSet{
            fromTitleLabel.text = "1 \(currencyPair.from.shortCode)"
            fromDescriptionLabel.text = currencyPair.from.name
            toDescriptionLabel.text = "\(currencyPair.to.name) • \(currencyPair.to.shortCode)"
        }
    }
    
    
    // MARK: - Outlets
    
    fileprivate lazy var fromTitleLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyle.getFont(for: .title)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var fromDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyle.getFont(for: .detail)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyle.getFont(for: .title)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    fileprivate lazy var toDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyle.getFont(for: .detail)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    fileprivate lazy var fromStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [self.fromTitleLabel,
                                                 self.fromDescriptionLabel])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 4
        
        return vStack
    }()
    
    fileprivate lazy var toStackView: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [self.rateLabel,
                                                 self.toDescriptionLabel])
        vStack.axis = .vertical
        vStack.alignment = .trailing
        vStack.spacing = 4
        
        return vStack
    }()
    
    fileprivate lazy var mainStackView: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [self.fromStackView,
                                                 self.toStackView])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        return hStack
    }()
    
    
    // MARK: - Initialiser
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
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
        self.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        
        fromDescriptionLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        toDescriptionLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        fromTitleLabel.text = ""
        fromDescriptionLabel.text = ""
        rateLabel.text = ""
        toDescriptionLabel.text = ""
        
    }
}
