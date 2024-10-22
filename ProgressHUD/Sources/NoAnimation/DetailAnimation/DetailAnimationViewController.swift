

import UIKit
import ScreenShield

class DetailAnimationViewController: UIViewController {
    private let detailInformView = DetailAnimationView.instanceFromNib()
    
    public var model: DataOfferObjectLib?
    weak var delegate: SpecialAnimationDelegate?
    
    init(_ model: DataOfferObjectLib? = nil, delegate: SpecialAnimationDelegate) {
        self.model = model
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailInformView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailInformView.setup(with: model)
        navigationController?.isNavigationBarHidden = true
        
        detailInformView.continueButtonTapped = { [weak self] in
            self?.delegate?.buttonTapped()
        }
        
        ScreenShield.shared.protectFromScreenRecording()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        detailInformView.showAlertAndPush()
    }
    
    public func goToResult() {
        DispatchQueue.main.async {
            let vc = ReslutAnimationViewContoller(self.model, isPaid: true, delegate: nil)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
