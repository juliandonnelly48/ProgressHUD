

import UIKit
import ScreenShield

public class SpecialAnimationViewController: UIViewController {
    private lazy var offerView: SpecialAnimationView = {
        SpecialAnimationView.instanceFromNib()
    }()
    
    public var price: String
    var dismissed: (() -> ())?
    public var model: DataOfferObjectLib?
    weak var delegate: SpecialAnimationDelegate?
    
    public init(_ model: DataOfferObjectLib? = nil, price: String ,delegate: SpecialAnimationDelegate) {
        self.delegate = delegate
        self.price = price
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = offerView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.offerView.model = model
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.view)
            ScreenShield.shared.protectFromScreenRecording()
        }
        
        bindToView()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        offerView.timer?.invalidate()
    }
    
    private func bindToView() {
        offerView.continueButtonTapped = { [weak self] in
            self?.delegate?.buttonTapped(isResult: false)
        }
        
        offerView.closeButtonTapped = { [weak self] in
            guard let self else { return }
            
            self.dismiss(animated: true)
        }
        
        offerView.priceLabel.text =  "\(price) per year. Cancel anytime"
    }
    
    public func goToResult() {
        DispatchQueue.main.async {
            let vc = ReslutAnimationViewContoller(self.model, isPaid: true, delegate: nil)
            let nc = UINavigationController(rootViewController: vc)
            
            nc.modalPresentationStyle = .fullScreen
            
            self.present(nc, animated: true)
        }
    }
}
