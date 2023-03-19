//
//  LabelCollectionView.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-19.
//

import UIKit

protocol LabelCollectionViewDelegate: AnyObject {
    func didSelectedAnswer(at index: Int)
}

class LabelCollectionView: UIView {

    // MARK: - Variables
    
    private let vm = LabelViewVM()
    weak var delegate: LabelTableViewDelegate?
    
    // MARK: - Components
    
    private var answerCollectioView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Init View
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(answerCollectioView)
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

extension LabelCollectionView {
    
    func configure(with model: [String]) {
        vm.setModel(with: model)
        
        DispatchQueue.main.async { [weak self] in
            self?.answerCollectioView.reloadData()
        }
    }
}

// MARK: - Set AnswerTableView

extension LabelCollectionView {
    
    private func setAnswerTableView() {
        
        answerCollectioView.delegate = self
        answerCollectioView.dataSource = self
        answerCollectioView.register(
            AnswerProgramaticalCVCell.self,
            forCellWithReuseIdentifier: AnswerProgramaticalCVCell.identifier
        )
        
        let constraintsAnswerTableView = [
            answerCollectioView.topAnchor.constraint(equalTo: self.topAnchor),
            answerCollectioView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            answerCollectioView.leftAnchor.constraint(equalTo: self.leftAnchor),
            answerCollectioView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraintsAnswerTableView)
    }
}

// MARK: - TableView DataSource

extension LabelCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.getModelCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerProgramaticalCVCell.identifier, for: indexPath) as? AnswerProgramaticalCVCell {
            
            if let answer = vm.getElement(at: indexPath.row) {
                cell.configure(with: answer)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - CollectionView Delegate

extension LabelCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectedAnswer(at: indexPath.row)
    }
}

// MARK: - CollectionView FlowLayout

extension LabelCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = answerCollectioView.frame.width
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
