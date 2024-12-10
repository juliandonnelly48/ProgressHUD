

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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let containerView = UIView()
            
            offerView.layer.cornerRadius = 20
            offerView.clipsToBounds = true
            containerView.backgroundColor = .white
            self.view.addSubview(containerView)
            containerView.addSubview(offerView)
            
            containerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            offerView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(800)
                make.width.equalTo(690)
            }
        } else {
            self.view.addSubview(offerView)
            
            offerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        self.offerView.model = model
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.view)
            ScreenShield.shared.protectFromScreenRecording()
        }
        
        bindToView()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.eventsFunc(event: .specialOffer1Show)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        offerView.timer?.invalidate()
    }
    
    private func bindToView() {
        offerView.continueButtonTapped = { [weak self] in
            self?.delegate?.eventsFunc(event: .specialOffer1ActionButton)
            if ProgressHUD.shared.isNewAnimationOn {
                guard let gap = self?.model?.gap else { return }
                
                let vc: UIViewController
                
                switch gap.orderIndex {
                case 1:
                    vc = NewAnimationOneViewController(model: gap.objecs[0], title: gap.title, delegate: self?.delegate)
                case 2:
                    vc = NewAnimationTwoViewController(model: gap.objecs[1], title: gap.title, delegate: self?.delegate)
                case 3:
                    vc = NewAnimationThreeViewController(model: gap.objecs[2], title: gap.title, delegate: self?.delegate)
                case 4:
                    vc = NewAnimationFourViewController(model: gap.objecs[3], title: gap.title, delegate: self?.delegate)
                default:
                    vc = NewAnimationOneViewController(model: gap.objecs[0], title: gap.title, delegate: self?.delegate)
                }
                
                let nc = UINavigationController(rootViewController: vc)
                
                nc.modalPresentationStyle = .fullScreen
                
                self?.present(nc, animated: true)
            } else {
                self?.delegate?.buttonTapped(isResult: false)
            }
        }
        
        offerView.closeButtonTapped = { [weak self] in
            guard let self else { return }
            
            self.dismiss(animated: true)
        }
        
        offerView.priceLabel.text =  "\(price) per year. Cancel anytime"
    }
    
    public func goToResult() {
        delegate?.eventsFunc(event: .specialOffer1Hide)
        DispatchQueue.main.async {
            let vc = ReslutAnimationViewContoller(self.model, isPaid: true, delegate: nil)
            let nc = UINavigationController(rootViewController: vc)
            
            nc.modalPresentationStyle = .fullScreen
            
            self.present(nc, animated: true)
        }
    }
}
