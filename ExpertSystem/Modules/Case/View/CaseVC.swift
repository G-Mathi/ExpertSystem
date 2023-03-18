//
//  CaseVC.swift
//  ExpertSystem
//
//  Created by Mathi on 2023-03-18.
//

import UIKit
import AlamofireImage

class CaseVC: UIViewController {
    
    // MARK: - Variables
    
    let vm = CaseVM()
    
    // MARK: Outlets
    
    @IBOutlet weak var lblCase: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
        initialCaseConfiguration()
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        self.title = .Case
        imageView.layer.cornerRadius = 8
        
        setScreenState(isEmpty: true)
    }
    
    private func setScreenState(isEmpty: Bool) {
        lblCase.isHidden = isEmpty
        imageView.isHidden = isEmpty
        answersTableView.isHidden = isEmpty
    }
    
    private func initialCaseConfiguration() {
        /// Check for initialCaseId availability
        guard let selectedCaseId = vm.getInitialCaseId() else {
            showFailedAlert(title: .Sorry, message: .UpdateApp)
            return
        }
        
        /// Call request to GET data in Background Thread
        /// As it called from a touch action and high priority QOS set to UserInitiated
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.getCaseAndConfigure(caseId: selectedCaseId)
        }
    }
}

// MARK: - Configure

extension CaseVC {
    
    private func configure() {
        
        /// If Selected case available configure the UI with appropirate data
        guard let selectedCase = vm.getSelectedCase() else {
            showFailedAlert(title: .Sorry, message: .SomethingWentWrong)
            return
        }
        
        setScreenState(isEmpty: false)
        
        lblCase.text = selectedCase.text
        answersTableView.reloadData()
        
        if let image = selectedCase.image, let url = URL(string: image) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.retrieveAndSetImage(for: url)
            }
        } else {
            imageView.image = nil
            imageView.isHidden = true
        }
    }
}

// MARK: - API Request

extension CaseVC {
    
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
                    self?.imageView.image = image
                }
            } else {
                self?.imageView.isHidden = true
            }
        })
    }
}


// MARK: - Show Alert

extension CaseVC {
    
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

// MARK: - TableView DataSource

extension CaseVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getAnswersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTVCell.identifier, for: indexPath) as? AnswerTVCell {
            
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

extension CaseVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return .Answers
    }
}
