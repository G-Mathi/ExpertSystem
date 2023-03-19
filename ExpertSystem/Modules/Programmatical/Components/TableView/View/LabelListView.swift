//
//  LabelListView.swift
//  ExpertSystem
//
//  Created by dilax on 2023-03-19.
//

import UIKit

protocol LabelListViewDelegate: AnyObject {
    func didSelectedAnswer(at index: Int)
}

class LabelListView: UIView {
    
    // MARK: - Variables
    
    private let vm = LabelListVM()
    weak var delegate: LabelListViewDelegate?
    
    // MARK: - Components
    
    private var answerTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
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

extension LabelListView {
    
    func configure(with model: [String]) {
        DispatchQueue.main.async { [weak self] in
            self?.answerTableView.reloadData()
        }
    }
}

// MARK: - Set AnswerTableView

extension LabelListView {
    
    private func setAnswerTableView() {
        
        answerTableView.delegate = self
        answerTableView.dataSource = self
        answerTableView.register(
            AnswerProgramaticalTVCell.self,
            forCellReuseIdentifier: AnswerProgramaticalTVCell.identifier
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

extension LabelListView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getModelCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AnswerProgramaticalTVCell.identifier, for: indexPath) as? AnswerProgramaticalTVCell {
            
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

extension LabelListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectedAnswer(at: indexPath.row)
    }
}
