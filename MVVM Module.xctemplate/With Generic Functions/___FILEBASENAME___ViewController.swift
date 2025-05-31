
import UIKit
import RxSwift
import RxCocoa

class ___VARIABLE_productName:identifier___View: UIViewController {
    
    
    let viewModel: ___VARIABLE_productName:identifier___ViewModel

    init(viewModel: ___VARIABLE_productName:identifier___ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
    }
}

extension ___VARIABLE_productName:identifier___ViewController {
    func bindViewModel() {
        let input = ___VARIABLE_productName:identifier___ViewModel.Input()
        let output = viewModel.transform(input)
    }
}
