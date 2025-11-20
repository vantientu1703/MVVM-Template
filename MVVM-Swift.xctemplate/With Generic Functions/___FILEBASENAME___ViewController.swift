
import UIKit

class ___VARIABLE_productName:identifier___ViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: ___VARIABLE_productName:identifier___ViewModel
    
    // MARK: - UI Components
    // Add your UI components here
    // Example: @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initialization
    init(viewModel: ___VARIABLE_productName:identifier___ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure UI components
        // Example: setupTableView()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Actions
    private func loadData() {
        viewModel.loadData()
    }
    
    // Add more action methods as needed
}

// MARK: - ViewModel Delegate
extension ___VARIABLE_productName:identifier___ViewController: ___VARIABLE_productName:identifier___ViewModelDelegate {
    
    func viewModelDidUpdate(_ viewModel: ___VARIABLE_productName:identifier___ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Update UI based on viewModel state
            // Example: self.tableView.reloadData()
            
            if viewModel.isLoading {
                // Show loading indicator
            } else {
                // Hide loading indicator
            }
        }
    }
    
    func viewModel(_ viewModel: ___VARIABLE_productName:identifier___ViewModel, didEncounterError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Show error alert
            self.showError(error)
        }
    }
    
    // MARK: - Helper Methods
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

