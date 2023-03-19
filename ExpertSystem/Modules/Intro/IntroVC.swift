//
//  IntroVC.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-19.
//

import UIKit

class IntroVC: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var btnProgrammatical: UIButton!
    @IBOutlet weak var btnStoryboard: UIButton!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        self.title = .Welcome
        view.backgroundColor = .systemBackground
        
        designButton(for: btnProgrammatical)
        designButton(for: btnStoryboard)
    }
    
    private func designButton(for button: UIButton) {
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func didTapOnProgrammatical(_ sender: UIButton) {
        let scenariosVC = ScenariosProgrammaticalVC()
        self.navigationController?.pushViewController(scenariosVC, animated: true)
    }
    
    @IBAction func didTapOnStoryboard(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: .StoryBoard.Main.rawValue, bundle: nil)
        if let scenariosVC = storyBoard.instantiateViewController(withIdentifier: .Controllers.Scenarios.rawValue) as? ScenariosVC {
            self.navigationController?.pushViewController(scenariosVC, animated: true)
        }
    }
}
