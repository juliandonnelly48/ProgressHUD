
import UIKit
import ProgressHUD
import ScreenShield

class ReslutViewContoller: UIViewController {
    private let resultView = ResultView.instanceFromNib()
    private let model: DataOfferObject?
    private let networkManager = NetworkManager()

    init(_ model: DataOfferObject? = nil) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let secureView = SecureField().secureContainer else { return }
        
        secureView.addSubview(resultView)
        resultView.snp.makeConstraints({$0.edges.equalToSuperview()})
        self.view.addSubview(secureView)
        secureView.snp.makeConstraints({$0.edges.equalToSuperview()})
        
        navigationController?.isNavigationBarHidden = true
        
        resultView.tariffButtonTapped = { [weak self] in
            let vc = SuperOfferViewController(tariff: nil)
            
            vc.modalPresentationStyle = .fullScreen
            
            self?.navigationController?.present(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultView.setup(with: model)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resultView.timerBzz?.invalidate()
    }
}

class SecureField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.isSecureTextEntry = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var secureContainer: UIView? {
        let secureView = self.subviews.filter({ subview in
            type(of: subview).description().contains("CanvasView")
        }).first
        secureView?.translatesAutoresizingMaskIntoConstraints = false
        secureView?.isUserInteractionEnabled = true
        return secureView
    }
    
    override var canBecomeFirstResponder: Bool {false}
    override func becomeFirstResponder() -> Bool {false}
}
