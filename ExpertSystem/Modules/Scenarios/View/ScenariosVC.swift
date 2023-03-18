//
//  ScenariosVC.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import UIKit

class ScenariosVC: UIViewController {
    
    // MARK: - Variables
    
    private let vm = ScenariosVM()
    
    // MARK: Outlets
    
    @IBOutlet weak var scenariosTableView: UITableView! {
        didSet {
            scenariosTableView.delegate = self
            scenariosTableView.dataSource = self
        }
    }
    
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

// MARK: - TableView DataSource

extension ScenariosVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate

extension ScenariosVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
