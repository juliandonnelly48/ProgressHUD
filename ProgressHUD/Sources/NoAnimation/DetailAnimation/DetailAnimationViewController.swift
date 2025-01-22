

import UIKit
import ScreenShield

class DetailAnimationViewController: UIViewController {
    private let detailInformView = DetailAnimationView.instanceFromNib()
    
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    
    init(_ model: AuthorizationOfferModel? = nil, delegate: SpecialAnimationDelegate) {
        self.model = model
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let containerView = UIView()
            
            detailInformView.layer.cornerRadius = 20
            detailInformView.clipsToBounds = true
            containerView.backgroundColor = .black
            self.view.addSubview(containerView)
            containerView.addSubview(detailInformView)
            
            containerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            detailInformView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.height.equalTo(806)
                make.width.equalTo(645)
                make.top.equalToSuperview().inset(50)
            }
        } else {
            self.view.addSubview(detailInformView)
            
            detailInformView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        detailInformView.setup(with: model)
        navigationController?.isNavigationBarHidden = true
        
        detailInformView.continueButtonTapped = { [weak self] in
            self?.delegate?.eventsFunc(event: .specialOffer2ActionButton)
            
            if ProgressHUD.shared.isNewAnimationOn {
                guard let gap = self?.model?.gap else { return }
                
                let vc: UIViewController
                
                switch gap.orderIndex {
                case 0:
                    self?.delegate?.buttonTapped(isResult: false)
                case 1:
                    vc = NewAnimationOneViewController(model: gap.objecs[0], title: gap.title, delegate: self?.delegate)
                case 2:
                    vc = NewAnimationTwoViewController(model: gap.objecs[1], title: gap.title, delegate: self?.delegate)
                case 3:
                    vc = NewAnimationThreeViewController(model: gap.objecs[2], title: gap.title, delegate: self?.delegate)
                case 4:
                    vc = NewAnimationFourViewController(model: gap.objecs[3], title: gap.titleTwo, delegate: self?.delegate)
                default:
                    vc = NewAnimationOneViewController(model: gap.objecs[0], title: gap.title, delegate: self?.delegate)
                }
                
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                self?.delegate?.buttonTapped(isResult: false)
            }
        }
        
        detailInformView.pushShow = { [weak self] in
            self?.delegate?.eventsFunc(event: .specialOffer2Notification)
            self?.delegate?.eventsFunc(event: .specialOffer2Main)
        }
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protectFromScreenRecording()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.eventsFunc(event: .specialOffer2ShowNext)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        detailInformView.showAlertAndPush()
    }
    
    public func goToResult() {
        delegate?.eventsFunc(event: .specialOffer2Hide)
        DispatchQueue.main.async {
            let vc = ReslutAnimationViewContoller(self.model, isPaid: true, delegate: nil)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
