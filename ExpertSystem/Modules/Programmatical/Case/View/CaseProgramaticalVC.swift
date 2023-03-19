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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
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
        setUIAccordingToCaseId(for: vm.getInitialCaseId())
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        self.title = .Case
        view.backgroundColor = .systemBackground
        
        setContainerQuestion()
        setAnswerTableView()
        
        setScreenState(isEmpty: true)
    }
    
    private func setScreenState(isEmpty: Bool) {
        lblQuestion.isHidden = isEmpty
        imageViewThumnail.isHidden = isEmpty
        answerTableView.isHidden = isEmpty
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

// MARK: - Configure

extension CaseProgramaticalVC {
    
    private func configure() {
        
        /// If Selected case available configure the UI with appropirate data
        guard let currentCase = vm.getCurrentCase() else {
            showFailedAlert(title: .Sorry, message: .SomethingWentWrong)
            return
        }
        
        setScreenState(isEmpty: false)
        
        lblQuestion.text = currentCase.text
        answerTableView.reloadData()
        
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

// MARK: - Set AnswerTableView

extension CaseProgramaticalVC {
    
    private func setAnswerTableView() {
        view.addSubview(answerTableView)
        
        answerTableView.delegate = self
        answerTableView.dataSource = self
        answerTableView.register(
            AnswerProgramaticalTVCell.self,
            forCellReuseIdentifier: AnswerProgramaticalTVCell.identifier
        )
        
        let safeArea = view.safeAreaLayoutGuide
        let constraintsAnswerTableView = [
            answerTableView.topAnchor.constraint(equalTo: containerQuestion.bottomAnchor, constant: 16),
            answerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            answerTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 12),
            answerTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -12)
        ]
        
        NSLayoutConstraint.activate(constraintsAnswerTableView)
    }
}

// MARK: - TableView DataSource

extension CaseProgramaticalVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getAnswersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AnswerProgramaticalTVCell.identifier, for: indexPath) as? AnswerProgramaticalTVCell {
            
            if let answer = vm.getAnswer(at: indexPath.row)?.text {
                cell.configure(with: answer)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate

extension CaseProgramaticalVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /// Get next case from the selection
        if let nextCaseId = vm.getAnswer(at: indexPath.row)?.caseId {
            vm.setNextCaseId(with: nextCaseId)
        }
        
        setUIAccordingToCaseId(for: vm.getNextCaseId())
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if vm.getAnswersCount() > 0 {
            return .Answers
        } else {
            return nil
        }
    }
}
