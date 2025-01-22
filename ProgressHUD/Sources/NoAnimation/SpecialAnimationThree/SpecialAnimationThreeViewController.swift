
import UIKit
import LocalAuthentication
import ScreenShield

public class SpecialAnimationThreeViewController: UIViewController {
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 34 : isVerySmallDevice ? 22 : 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 24 : isVerySmallDevice ? 16 : 22, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var linesLabel: UILabel = {
        let label = UILabel()
        label.text = (model?.objectTwo?.description.items_title ?? "") + createText()
        label.font = .systemFont(ofSize: isVerySmallDevice ? 16 : 18, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let lowImageIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var lowLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: isVerySmallDevice ? 14 : 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 115/255, green: 199/255, blue: 0/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: isVerySmallDevice ? 16 : 20, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let containerView = UIView()
    
    public var model: AuthorizationOfferModel?
    weak var delegate: SpecialAnimationDelegate?
    
    public init(_ model: AuthorizationOfferModel? = nil, delegate: SpecialAnimationDelegate) {
        self.model = model
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.topImageView)
            ScreenShield.shared.protect(view: self.titleLabel)
            ScreenShield.shared.protect(view: self.subtitleLabel)
            ScreenShield.shared.protect(view: self.linesLabel)
            ScreenShield.shared.protect(view: self.lowImageIconView)
            ScreenShield.shared.protect(view: self.lowLabel)
            ScreenShield.shared.protect(view: self.actionButton)
            ScreenShield.shared.protectFromScreenRecording()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.eventsFunc(event: .specialOffer3Show)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func createText() -> String {
        var text: String = ""
        
        model?.objectTwo?.description.items?.forEach {
            text.append("\n \($0)")
        }
        
        return text
    }

    private func setUI() {
        guard let mainUrl = URL(string: model?.objectTwo?.dark_blue.main_img ?? "") else { return }
        
        topImageView.kf.setImage(with: mainUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        
        titleLabel.text = model?.objectTwo?.dark_blue.title
        subtitleLabel.text = model?.objectTwo?.dark_blue.subtitle
        
        guard let smallUrl = URL(string: model?.objectTwo?.dark_blue.small_img ?? "") else { return }
        
        lowImageIconView.kf.setImage(with: smallUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        lowLabel.text = model?.objectTwo?.dark_blue.footer_text
        
        hStack.addArrangedSubview(lowImageIconView)
        hStack.addArrangedSubview(lowLabel)
        
        actionButton.setTitle(model?.objectTwo?.dark_blue.btn_title, for: .normal)
        actionButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            containerView.backgroundColor = UIColor(red: 29/255, green: 34/255, blue: 57/255, alpha: 1)
            self.view.addSubview(containerView)
            
            containerView.addSubview(topImageView)
            containerView.addSubview(titleLabel)
            containerView.addSubview(subtitleLabel)
            containerView.addSubview(linesLabel)
            containerView.addSubview(hStack)
            containerView.addSubview(actionButton)
            
            containerView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(627)
                make.width.equalTo(400)
            }
        } else {
            view.addSubview(topImageView)
            view.addSubview(titleLabel)
            view.addSubview(subtitleLabel)
            view.addSubview(linesLabel)
            view.addSubview(hStack)
            view.addSubview(actionButton)
        }
    }
    
    private func setConstraints() {
        view.backgroundColor = UIColor(red: 29/255, green: 34/255, blue: 57/255, alpha: 1)
        
        topImageView.snp.makeConstraints { make in
            if UIDevice.current.userInterfaceIdiom == .pad {
                make.top.equalTo(containerView.snp.top)
            } else {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            }
            
            make.width.equalTo(UIDevice.current.userInterfaceIdiom == .pad ? 252 : isVerySmallDevice ? 57 : 109)
            make.height.equalTo(UIDevice.current.userInterfaceIdiom == .pad ? 225 : isVerySmallDevice ? 51 : 97)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(topImageView.snp.bottom).offset(UIDevice.current.userInterfaceIdiom == .pad ? 35 : 15)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        linesLabel.snp.makeConstraints { make in
            if UIDevice.current.userInterfaceIdiom == .pad {
                make.top.equalTo(subtitleLabel.snp.bottom).inset(-35)
            } else {
                if self.isVerySmallDevice {
                    make.top.equalTo(subtitleLabel.snp.bottom).inset(-48)
                } else {
                    make.top.equalTo(view.snp.centerY)
                }
            }
            
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-35)
        }
        
        actionButton.snp.makeConstraints { make in
            if UIDevice.current.userInterfaceIdiom == .pad {
                make.bottom.equalTo(containerView.snp.bottom)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            }
            make.leading.equalToSuperview().offset(37)
            make.trailing.equalToSuperview().offset(-37)
            make.height.equalTo(50)
        }
        
        lowImageIconView.snp.makeConstraints { make in
            make.width.equalTo(20)
        }
        
        hStack.snp.makeConstraints { make in
            make.bottom.equalTo(actionButton.snp.top).offset(-15)
            make.leading.equalToSuperview().offset(37)
            make.trailing.equalToSuperview().offset(-37)
        }
    }
    
    func showSingleButtonAlert() {
        let alert = UIAlertController(title: model?.objectTwo?.dark_blue.title, message: model?.objectTwo?.dark_blue.subtitle, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.delegate?.eventsFunc(event: .specialOffer3FirstButtonTap)
            self?.showTwoButtonAlert()
        }
        
        alert.addAction(okAction)
        delegate?.eventsFunc(event: .specialOffer3ShowFirst)
        present(alert, animated: true, completion: nil)
    }
    
    func showTwoButtonAlert() {
        let alertMess: String
        
        if LAContext().biometricType == .none {
            alertMess = model?.objectTwo?.dark_blue.al_subtitle_no_bio ?? ""
        } else {
            let authText = LAContext().biometricType.rawValue
            
            alertMess = String(format: model?.objectTwo?.dark_blue.al_subtitle ?? "", authText)
        }

        let alert = UIAlertController(title: model?.objectTwo?.dark_blue.al_title, message: alertMess, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.delegate?.eventsFunc(event: .specialOffer3SecondButtonDis)
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.delegate?.eventsFunc(event: .specialOffer3ActionButton)
            if ProgressHUD.shared.isNewAnimationOn {
                guard let gap = self?.model?.gap else { return }
                
                let vc: UIViewController
                
                switch gap.orderIndex {
                case 0:
                    self?.delegate?.buttonTapped(isResult: false)
                    return

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
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        delegate?.eventsFunc(event: .specialOffer3ShowSecond)
        present(alert, animated: true, completion: nil)
    }

    @objc private func buttonTap() {
        showSingleButtonAlert()
    }
    
    public func goToResult() {
        delegate?.eventsFunc(event: .specialOffer3Hide)
        DispatchQueue.main.async {
            let vc = ReslutAnimationViewContoller(self.model, isPaid: true, delegate: nil)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension LAContext {
    enum BiometricType: String {
        case none = "FaceID"
        case touchID = "Touch ID"
        case faceID = "Face ID"
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        }
        
        return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}
