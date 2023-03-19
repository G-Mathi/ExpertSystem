//
//  LabelListView.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-19.
//

import UIKit

class LabelTableView: UIView {
    
    // MARK: - Variables
    
    private let vm = LabelViewVM()
    weak var delegate: OneLabelViewDelegate?
    
    // MARK: - Components
    
    private var answerTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Init View
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(answerTableView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
    
    // MARK: - SetUI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setAnswerTableView()
    }
}

// MARK: - Configure

extension LabelTableView {
    
    func configure(with model: [String], scenario: StateScenario) {
        vm.setModel(with: model)
        vm.scenario = scenario
        
        DispatchQueue.main.async { [weak self] in
            self?.answerTableView.reloadData()
        }
    }
}

// MARK: - Set AnswerTableView

extension LabelTableView {
    
    private func setAnswerTableView() {
        
        answerTableView.delegate = self
        answerTableView.dataSource = self
        answerTableView.register(
            LabelTVCell.self,
            forCellReuseIdentifier: LabelTVCell.identifier
        )
        
        let constraintsAnswerTableView = [
            answerTableView.topAnchor.constraint(equalTo: self.topAnchor),
            answerTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            answerTableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            answerTableView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraintsAnswerTableView)
    }
}

// MARK: - TableView DataSource

extension LabelTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getModelCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LabelTVCell.identifier, for: indexPath) as? LabelTVCell {
            
            if let answer = vm.getElement(at: indexPath.row) {
                cell.configure(with: answer)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate

extension LabelTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectedElement(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if vm.getModelCount() > 0 {
            switch vm.scenario {
            case .Scenarios:
                return nil
            case .Answers:
                return .Answers
            }
        } else {
            return nil
        }
    }
}
