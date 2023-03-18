//
//  AnswerTVCell.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import UIKit

class AnswerTVCell: UITableViewCell {
    
    // MARK: - Oultes

    @IBOutlet weak var lblAnswer: UILabel!
    
    // MARK: - Init View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        accessoryType = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

// MARK: - SetupUI

extension AnswerTVCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .yellow
        contentView.layer.cornerRadius = 20
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lblAnswer.text = nil
    }
}

// MARK: - Configure

extension AnswerTVCell {
    
    func configure(with answer: String?) {
        if let answer {
            lblAnswer.text = answer
        }
    }
}

