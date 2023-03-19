//
//  CaseProgramaticalVC.swift
//  ExpertSystem
//
//  Created by dilax on 2023-03-19.
//

import UIKit

class CaseProgramaticalVC: UIViewController {

    // MARK: - Variables
    
    // MARK: Components
    
    // Question View
    private var containerQuestion: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    private var lblQuestion: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        return label
    }()
    
    private var imageViewThumnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    // Answer TableView
    private var answerTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        
    }
    
    // MARK: - Configure
    
    private func configure() {
        
    }
}
