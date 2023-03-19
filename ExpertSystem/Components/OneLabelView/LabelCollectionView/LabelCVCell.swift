//
//  LabelCVCell.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-19.
//

import UIKit

class LabelCVCell: UICollectionViewCell {
    static let identifier = "LabelCVCell"
    
    // MARK: - Components
    
    private var lblAnswer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    
    // MARK: - Init View
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(lblAnswer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    // MARK: - Setup UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lblAnswer.text = nil
    }
    
    private func setupUI() {
        contentView.backgroundColor = .link
        contentView.layer.cornerRadius = 8
        setLabelAnswer()
    }
}

// MARK: - set LabelAnswer

extension LabelCVCell {
    
    private func setLabelAnswer() {
        let constraintsLabel = [
            lblAnswer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            lblAnswer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            lblAnswer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            lblAnswer.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
        ]
        
        NSLayoutConstraint.activate(constraintsLabel)
    }
}

// MARK: - Configure

extension LabelCVCell {
    
    func configure(with answer: String?) {
        if let answer {
            lblAnswer.text = answer
        }
    }
}

