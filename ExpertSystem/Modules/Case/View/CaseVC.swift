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
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.getCaseAndConfigure()
        }
    }
    
    // MARK: - SetupUI
    
    private func setupUI() {
        
    }
}

// MARK: - Configure

extension CaseVC {
    
    private func configure() {
        guard let selectedCase = vm.getSelectedCase() else {
            /// Show alert
            return
        }
        
        lblCase.text = selectedCase.text
        answersTableView.reloadData()
        
        if let image = selectedCase.image, let url = URL(string: image) {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.retrieveAndSetImage(for: url)
            }
        } else {
            imageView.image = nil
            imageView.isHidden = true
        }
    }
    
    private func retrieveAndSetImage(for url: URL) {
        let imageDownloader = ImageDownloader(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            downloadPrioritization: .fifo,
            maximumActiveDownloads: 1,
            imageCache: AutoPurgingImageCache()
        )
        
        let urlRequest = URLRequest(url: url)

        imageDownloader.download(urlRequest, completion:  { response in
            if case .success(let image) = response.result {
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        })
    }
}

// MARK: - API Request

extension CaseVC {
    
    // MARK: GET Scenarios
    
    private func getCaseAndConfigure() {
        vm.getCaseInfo { [weak self] success, message in
            if success {
                DispatchQueue.main.async {
                    self?.configure()
                }
            } else {
                if let message {
                    self?.showAlert(title: .Alert, message: message)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            AlertProvider.showAlert(
                target: self,
                title: title,
                message: message,
                action: AlertAction(title: .Dismiss)
            )
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
}
