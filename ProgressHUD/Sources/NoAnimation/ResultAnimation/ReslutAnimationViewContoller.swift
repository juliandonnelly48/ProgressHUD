
import UIKit
import ScreenShield

public class ReslutAnimationViewContoller: UIViewController, SpecialAnimationDelegate {
    public func buttonTapped() {
        delegate?.buttonTapped()
    }
    
    private let resultView = ResultAnimationView.instanceFromNib()
    private let model: DataOfferObjectLib?
    private let isPaid: Bool
//    private let networkManager = NetworkManager()

    weak var delegate: SpecialAnimationDelegate?
    
    public init(_ model: DataOfferObjectLib? = nil, isPaid: Bool, delegate: SpecialAnimationDelegate) {
        self.model = model
        self.delegate = delegate
        self.isPaid = isPaid
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let secureView = SecureField().secureContainer else { return }
        
        secureView.addSubview(resultView)
        resultView.snp.makeConstraints({$0.edges.equalToSuperview()})
        self.view.addSubview(secureView)
        secureView.snp.makeConstraints({$0.edges.equalToSuperview()})
        
        navigationController?.isNavigationBarHidden = true
        
        resultView.tariffButtonTapped = { [weak self] in
            guard let self else { return }
            
            let vc = SuperAnimationViewController(price: nil, delegate: self)
            
            vc.modalPresentationStyle = .fullScreen
            
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultView.setup(with: model, isTarifPaidAndActive: isPaid)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
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
