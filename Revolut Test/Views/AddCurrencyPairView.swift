//
//  AddCurrencyPairView.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 19/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

protocol AddCurrencyPairViewDelegate: class {
    func addCurrencyPairButtonTapped()
}

class AddCurrencyPairView: UIView {
    
    // MARK: - Properties
    weak var delegate: AddCurrencyPairViewDelegate?
    fileprivate let layoutMode: LayoutMode
    
    enum LayoutMode {
        case vertical
        case horizontal
    }
    
    // MARK: - Outlets
    
    lazy var plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageData.getImage(for: .add)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = ImageData.getText(for: .add).title
        label.textColor = ColorTheme.accent
        label.textAlignment = .center
        label.font = TextStyle.getFont(for: .title)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ImageData.getText(for: .add).description
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = TextStyle.getFont(for: .body)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.plusImageView,
                                                    self.titleLabel])
        stack.distribution = .fill
        stack.alignment = .center
        
        switch layoutMode {
        case .vertical:
            stack.addArrangedSubview(self.descriptionLabel)
            stack.axis = .vertical
            stack.spacing = 8
            self.titleLabel.textAlignment = .center
            
        case .horizontal:
            stack.axis = .horizontal
            stack.spacing = 16
            self.titleLabel.textAlignment = .left
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addCurrencyPair(gesture:)))
        
        stack.addGestureRecognizer(tapGesture)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // MARK: - Initialiser
    
    init(layoutMode: LayoutMode) {
        self.layoutMode = layoutMode
        super.init(frame: .zero)
        self.setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupStackView() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        plusImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        plusImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc fileprivate func addCurrencyPair(gesture: UITapGestureRecognizer) {
            
        delegate?.addCurrencyPairButtonTapped()
    }
}
