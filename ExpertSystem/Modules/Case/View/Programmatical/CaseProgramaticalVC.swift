//
//  CaseProgramaticalVC.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-19.
//

import UIKit
import AlamofireImage

class CaseProgramaticalVC: UIViewController {
    
    // MARK: - Variables
    
    let vm = CaseVM()
    
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
        label.backgroundColor = .clear
        return label
    }()
    
    private var imageViewThumnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private var answerView: LabelCollectionView = {
        let view = LabelCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUIAccordingToCaseId(for: vm.getInitialCaseId())
    }
}

// MARK: - SetupUI

extension CaseProgramaticalVC {
    
    private func setupUI() {
        self.title = .Case
        view.backgroundColor = .systemBackground
        
        setContainerQuestion()
        setAnswerView()
        setScreenState(isEmpty: true)
    }
    
    private func setScreenState(isEmpty: Bool) {
        lblQuestion.isHidden = isEmpty
        imageViewThumnail.isHidden = isEmpty
        answerView.isHidden = isEmpty
    }
    
    private func setUIAccordingToCaseId(for caseId: Int?) {
        /// Check for CaseId availability, Incase caseId missed from backend show alert
        guard let caseId else {
            showFailedAlert(title: .Sorry, message: .UpdateApp)
            return
        }
        
        /// Call request to GET data in Background Thread
        /// As it called from a touch action and high priority QOS set to UserInitiated
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.getCaseAndConfigure(caseId: caseId)
        }
    }
}

// MARK: - Set QuestionView

extension CaseProgramaticalVC {
    
    private func setContainerQuestion() {
        view.addSubview(containerQuestion)
        
        let safeArea = view.safeAreaLayoutGuide
        let constraintsContainerQuestion = [
            containerQuestion.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            containerQuestion.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 12),
            containerQuestion.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(constraintsContainerQuestion)
        
        addViewsToContainer()
        setImageView()
    }
    
    private func addViewsToContainer() {
        containerQuestion.addArrangedSubview(lblQuestion)
        containerQuestion.addArrangedSubview(imageViewThumnail)
    }
    
    private func setImageView() {
        imageViewThumnail.heightAnchor.constraint(equalTo: imageViewThumnail.widthAnchor, multiplier: 0.5).isActive = true
    }
}

// MARK: - Set AnswerView

extension CaseProgramaticalVC {
    
    private func setAnswerView() {
        view.addSubview(answerView)
        
        answerView.delegate = self
        
        let safeArea = view.safeAreaLayoutGuide
        let constraintsAnswerColectionView = [
            answerView.topAnchor.constraint(equalTo: containerQuestion.bottomAnchor, constant: 16),
            answerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            answerView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 12),
            answerView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraintsAnswerColectionView)
    }
}

// MARK: - Configure

extension CaseProgramaticalVC {
    
    private func configure() {
        
        /// If Selected case available configure the UI with appropirate data
        guard let currentCase = vm.getCurrentCase() else {
            showFailedAlert(title: .Sorry, message: .SomethingWentWrong)
            return
        }
        
        /// Set Screen State
        setScreenState(isEmpty: false)
        
        /// Set Question
        lblQuestion.text = currentCase.text
        
        /// Configuration for the view to show the list
        if let answers = currentCase.answers {
            let model = answers.map { scenario in
                if let text = scenario.text {
                    return text
                } else {
                    return ""
                }
            }
            answerView.configure(with: model, scenario: .Answers)
        }
        
        /// Retrive or Download and Show Thumnail
        if let image = currentCase.image, let url = URL(string: image) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.retrieveAndSetImage(for: url)
            }
        } else {
            imageViewThumnail.image = nil
            imageViewThumnail.isHidden = true
        }
    }
}

// MARK: - API Request

extension CaseProgramaticalVC {
    
    // MARK: GET Scenarios
    
    private func getCaseAndConfigure(caseId: Int) {
        vm.getCaseInfo(caseId: caseId) { [weak self] success, message in
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
    
    // MARK: GET Thumnail
    
    /*
     * Download or retreive image from cache in backgorund thread using AlamofireImage,
     * And set the image using main thred.
     * If image not available, hide the ImageView
     */
    private func retrieveAndSetImage(for url: URL) {
        let imageDownloader = ImageDownloader(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            downloadPrioritization: .fifo,
            maximumActiveDownloads: 1,
            imageCache: AutoPurgingImageCache()
        )
        
        let urlRequest = URLRequest(url: url)
        
        imageDownloader.download(urlRequest, completion:  { [weak self] response in
            if case .success(let image) = response.result {
                DispatchQueue.main.async { [weak self] in
                    self?.imageViewThumnail.image = image
                }
            } else {
                self?.imageViewThumnail.isHidden = true
            }
        })
    }
}

// MARK: - Show Alert

extension CaseProgramaticalVC {
    
    private func showFailedAlert(title: String, message: String) {
        AlertProvider.showAlertWithActions(
            target: self,
            title: title,
            message: message,
            actions: [AlertAction(title: .Dismiss)]
        ) { action in
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - OneLabelView Delegate

extension CaseProgramaticalVC: OneLabelViewDelegate {
    
    func didSelectedElement(at index: Int) {
        /// Get next case from the selection
        if let nextCaseId = vm.getAnswer(at: index)?.caseId {
            vm.setNextCaseId(with: nextCaseId)
        }
        
        setUIAccordingToCaseId(for: vm.getNextCaseId())
    }
}
