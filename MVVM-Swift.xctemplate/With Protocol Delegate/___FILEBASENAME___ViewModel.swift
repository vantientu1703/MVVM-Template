
import Foundation

// MARK: - ViewModel Delegate Protocol
protocol ___VARIABLE_productName:identifier___ViewModelDelegate: AnyObject {
    func viewModelDidUpdate(_ viewModel: ___VARIABLE_productName:identifier___ViewModel)
    func viewModel(_ viewModel: ___VARIABLE_productName:identifier___ViewModel, didEncounterError error: Error)
    // Add more delegate methods as needed
}

// MARK: - ViewModel
class ___VARIABLE_productName:identifier___ViewModel {
    
    // MARK: - Properties
    weak var delegate: ___VARIABLE_productName:identifier___ViewModelDelegate?
    
    let useCase: ___VARIABLE_productName:identifier___Usecase
    let navigator: ___VARIABLE_productName:identifier___Navigator
    
    // MARK: - State
    private(set) var isLoading: Bool = false {
        didSet {
            delegate?.viewModelDidUpdate(self)
        }
    }
    
    // Add your data properties here
    // Example: private(set) var items: [Item] = []
    
    // MARK: - Initialization
    init(useCase: ___VARIABLE_productName:identifier___Usecase, navigator: ___VARIABLE_productName:identifier___Navigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    // MARK: - Public Methods
    func loadData() {
        isLoading = true
        // Call useCase methods here
        // Example:
        // useCase.fetchData { [weak self] result in
        //     guard let self = self else { return }
        //     self.isLoading = false
        //     switch result {
        //     case .success(let data):
        //         // Handle success
        //         self.delegate?.viewModelDidUpdate(self)
        //     case .failure(let error):
        //         self.delegate?.viewModel(self, didEncounterError: error)
        //     }
        // }
    }
    
    // Add more public methods as needed
}

