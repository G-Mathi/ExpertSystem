//
//  AnswerProgramaticalTVCell.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-19.
//

import UIKit

class LabelTVCell: UITableViewCell {
    static let identifier = "LabelTVCell"
    
    // MARK: - Components
    
    private var lblAnswer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    
    // MARK: - Init View
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .default
        accessoryType = .none
        
        contentView.addSubview(lblAnswer)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        setLabelAnswer()
        
        contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
}

// MARK: - set LabelAnswer

extension LabelTVCell {
    
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

extension LabelTVCell {
    
    func configure(with answer: String?) {
        if let answer {
            lblAnswer.text = answer
        }
    }
}
