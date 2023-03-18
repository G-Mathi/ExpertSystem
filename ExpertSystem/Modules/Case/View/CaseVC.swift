//
//  CaseVC.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import UIKit

class CaseVC: UIViewController {

    // MARK: - Variables
    
    private let vm = CaseVM()
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblCase: UILabel!
    
    @IBOutlet weak var answersTableView: UITableView! {
        didSet {
            answersTableView.delegate = self
            answersTableView.dataSource = self
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
}

// MARK: - Configure

extension CaseVC {
    
    private func configure() {
        guard let selectedCase = vm.selectedCase else {
            /// Show alert
            return
        }
        
        lblCase.text = selectedCase.text
//        imageView.image
        answersTableView.reloadData()
    }
}

// MARK: - TableView DataSource

extension CaseVC: UITableViewDataSource {
    
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

extension CaseVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
