//
//  ScenariosProgrammaticalVC.swift
//  ExpertSystem
//
//  Created by dilax on 2023-03-19.
//

import UIKit

class ScenariosProgrammaticalVC: UIViewController {

    // MARK: - Variables
    
    private let vm = ScenariosVM()
    
    // MARK: Outlets
    
    private var scenarioView: LabelCollectionView = {
        let view = LabelCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private var lblNoContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17.0, weight: .medium)
        label.backgroundColor = .clear
        return label
    }()
    
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
        view.backgroundColor = .systemBackground
        
        setAnswerView()
        setLblNoContent()
        
        setScreenState(isEmpty: true)
    }
    
    private func setScreenState(isEmpty: Bool) {
        scenarioView.isHidden = isEmpty
        lblNoContent.isHidden = !isEmpty
    }
}

// MARK: - Set ScenarioView

extension ScenariosProgrammaticalVC {
    
    private func setAnswerView() {
        view.addSubview(scenarioView)
        
        scenarioView.delegate = self
        
        let safeArea = view.safeAreaLayoutGuide
        let constraintsAnswerColectionView = [
            scenarioView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            scenarioView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scenarioView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 12),
            scenarioView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraintsAnswerColectionView)
    }
}

// MARK: - Set lblNoContent

extension ScenariosProgrammaticalVC {
    
    private func setLblNoContent() {
        view.addSubview(lblNoContent)
        
        let safeArea = view.safeAreaLayoutGuide
        let constraintsAnswerColectionView = [
            lblNoContent.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            lblNoContent.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            lblNoContent.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            lblNoContent.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraintsAnswerColectionView)
    }
}

// MARK: - Configure

extension ScenariosProgrammaticalVC {
    
    private func configure() {
        guard let scenarios = vm.getScenarios() else {
            showFailedAlert(title: .Sorry, message: .SomethingWentWrong)
            return
        }
        
        setScreenState(isEmpty: false)
        
        /// Configuration for the view to show the list
        let model = scenarios.map { scenario in
            if let text = scenario.text {
                return text
            } else {
                return ""
            }
        }
        scenarioView.configure(with: model, scenario: .Scenarios)
    }
}

// MARK: - API Request

extension ScenariosProgrammaticalVC {
    
    // MARK: GET Scenarios
    
    private func getScenariosAndConfigure() {
        vm.getScenarios { [weak self] success, message in
            if success {
                DispatchQueue.main.async {
                    self?.configure()
                }
            } else {
                if let message {
                    DispatchQueue.main.async {
                        self?.showFailedAlert(title: .Sorry, message: message)
                    }
                }
            }
        }
    }
}

// MARK: - Show Alert

extension ScenariosProgrammaticalVC {
    
    private func showFailedAlert(title: String, message: String) {
        AlertProvider.showAlert(
            target: self,
            title: title,
            message: message,
            action: AlertAction(title: .Dismiss)
        )
    }
}

// MARK: - OneLabelView Delegate

extension ScenariosProgrammaticalVC: OneLabelViewDelegate {
    
    func didSelectedElement(at index: Int) {
        if let caseId = vm.getScenario(at: index)?.caseId {
            
            let caseVC = CaseProgramaticalVC()
            caseVC.vm.setInitialCaseId(with: caseId)
            self.navigationController?.pushViewController(caseVC, animated: true)
        }
    }
}
