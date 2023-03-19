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
    @IBOutlet weak var lblNoContent: UILabel!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.getScenariosAndConfigure()
        }
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        self.title = .Scenario
        scenariosTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        setScreenState(isEmpty: true)
    }
    
    private func setScreenState(isEmpty: Bool) {
        scenariosTableView.isHidden = isEmpty
        lblNoContent.isHidden = !isEmpty
    }
}

// MARK: - Configure

extension ScenariosVC {
    
    private func configure() {
        setScreenState(isEmpty: false)
        scenariosTableView.reloadData()
    }
}

// MARK: - API Request

extension ScenariosVC {
    
    // MARK: GET Scenarios
    
    private func getScenariosAndConfigure() {
        vm.getScenarios { [unowned self] success, message in
            if success {
                DispatchQueue.main.async {
                    self.configure()
                }
            } else {
                if let message {
                    DispatchQueue.main.async {
                        AlertProvider.showAlert(
                            target: self,
                            title: .Alert,
                            message: message,
                            action: AlertAction(title: .Dismiss)
                        )
                    }
                }
            }
        }
    }
}

// MARK: - TableView DataSource

extension ScenariosVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getScenariosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ScenarioTVCell.identifier, for: indexPath) as? ScenarioTVCell {
            
            if let model = vm.getScenario(at: indexPath.row) {
                cell.configure(with: model)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate

extension ScenariosVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let caseId = vm.getScenario(at: indexPath.row)?.caseId {
            
//            let storyBoard = UIStoryboard(name: .StoryBoard.Main.rawValue, bundle: nil)
//            if let caseVC = storyBoard.instantiateViewController(withIdentifier: .Controllers.Case.rawValue) as? CaseVC {
//                caseVC.vm.setInitialCaseId(with: caseId)
//                self.navigationController?.pushViewController(caseVC, animated: true)
//            }
            
            let caseVC = CaseProgramaticalVC()
            caseVC.vm.setInitialCaseId(with: caseId)
            self.navigationController?.pushViewController(caseVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
