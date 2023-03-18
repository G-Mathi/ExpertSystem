//
//  ScenarioTVCell.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import UIKit

class ScenarioTVCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblScenario: UILabel!
    
    // MARK: - Init View
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
    }
}

// MARK: - SetupUI

extension ScenarioTVCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .yellow
        contentView.layer.cornerRadius = 20
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lblScenario.text = nil
    }
}

// MARK: - Configure

extension ScenarioTVCell {
    
    func configure(with model: Scenario) {
        if let scenario = model.text {
            lblScenario.text = scenario
        }
    }
}


