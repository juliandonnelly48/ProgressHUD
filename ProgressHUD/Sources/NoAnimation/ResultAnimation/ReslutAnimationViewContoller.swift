
import UIKit

public class ReslutAnimationViewContoller: UIViewController, SpecialAnimationDelegate {
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    
    public func eventsFunc(event: EventsName) {
        delegate?.eventsFunc(event: event)
    }
    
    public func buttonTapped(isResult: Bool) {
        delegate?.buttonTapped(isResult: isResult)
    }
    
    private let resultView = ResultAnimationView.instanceFromNib()
    public var model: AuthorizationOfferModel?
    public var isPaid: Bool
    
    weak var delegate: SpecialAnimationDelegate?
    
    public init(_ model: AuthorizationOfferModel? = nil, isPaid: Bool, delegate: SpecialAnimationDelegate?) {
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
        
        if !ProgressHUD.shared.isShow {
            guard let secureView = SecureField().secureContainer else { return }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let containerView = UIView()
                
                containerView.backgroundColor = .white
                containerView.addSubview(secureView)
                secureView.addSubview(resultView)
                secureView.snp.makeConstraints({$0.edges.equalToSuperview()})
                self.view.addSubview(containerView)
            
                containerView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }

                resultView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.height.equalTo(1032)
                    make.leading.trailing.equalToSuperview().inset(100)
                }
            } else {
                if isVerySmallDevice {
                    let scrollView = UIScrollView()
                    
                    scrollView.backgroundColor = .white
                    scrollView.isScrollEnabled = true
                    scrollView.showsVerticalScrollIndicator = false
                    view.addSubview(scrollView)
                    scrollView.addSubview(secureView)
                    secureView.addSubview(resultView)
                    
                    scrollView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    
                    secureView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    
                    resultView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                        make.width.equalTo(scrollView)
                    }
                } else {
                    secureView.addSubview(resultView)
                    resultView.snp.makeConstraints({$0.edges.equalToSuperview()})
                    self.view.addSubview(secureView)
                    secureView.snp.makeConstraints({$0.edges.equalToSuperview()})
                }
            }
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let containerView = UIView()
                
                containerView.backgroundColor = .white
                self.view.addSubview(containerView)
                containerView.addSubview(resultView)
                
                containerView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                resultView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.height.equalTo(1032)
                    make.leading.trailing.equalToSuperview().inset(100)
                }
            } else {
                if isVerySmallDevice {
                    let scrollView = UIScrollView()
                    
                    scrollView.backgroundColor = .white
                    scrollView.isScrollEnabled = true
                    scrollView.showsVerticalScrollIndicator = false
                    view.addSubview(scrollView)
                    scrollView.addSubview(resultView)
                    
                    scrollView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    
                    resultView.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                        make.width.equalTo(scrollView)
                    }
                } else {
                    self.view.addSubview(resultView)
                    
                    resultView.snp.makeConstraints({$0.edges.equalToSuperview()})
                }
            }
        }
        navigationController?.isNavigationBarHidden = true
        
        resultView.tariffButtonTapped = { [weak self] in
            guard let self else { return }
            
            let vc = SuperAnimationViewController(price: nil, delegate: self)
            
            vc.modalPresentationStyle = .fullScreen
            
            self.navigationController?.present(vc, animated: true)
        }
        
        resultView.openSheetVCTapped = { [weak self] in
            guard let self else { return }
            
            let vc = SheetViewController(model?.sheet, delegate: self.delegate) {
                self.resultView.setup(with: self.model, isTarifPaidAndActive: self.isPaid)
            }
            
            vc.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(vc, animated: false)
        }
        
        resultView.sendEvent = { [weak self] event in
            self?.delegate?.eventsFunc(event: event)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventsFunc(event: .specialOffer5Show)
        resultView.setup(with: model, isTarifPaidAndActive: isPaid)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resultView.timerBzz?.invalidate()
    }
}

final class SecureField: UITextField {
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
