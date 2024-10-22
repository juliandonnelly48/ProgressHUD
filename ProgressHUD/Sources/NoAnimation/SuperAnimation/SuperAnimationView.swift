
import UIKit
import Lottie

class SuperAnimationView: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = SuperAnimationView
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var cancellabel: UILabel!
    
    @IBOutlet weak var lottieAnimationView: UIView! {
        didSet {
            let anView = LottieAnimationView()
            lottieAnimationView.addSubview(anView)
            anView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            anView.animation = LottieAnimation.named("superAnimation")
            anView.loopMode = .autoReverse
            anView.contentMode = .scaleAspectFill
            anView.backgroundBehavior = .pauseAndRestore
            anView.backgroundColor = .clear
            anView.play()
        }
    }
    
    @IBOutlet weak var infoview: UIView! {
        didSet {
            infoview.applyGradient(
                isVertical: false,
                colorArray: [
                    UIColor().hexStringToUIColor(hex: "#FFD39E"),
                    UIColor().hexStringToUIColor(hex: "#FF9B43"),
                    UIColor().hexStringToUIColor(hex: "#FFC49D"),
                    UIColor().hexStringToUIColor(hex: "#F86C1E")
                ]
            )
        }
    }
    
    @IBOutlet weak var buybutton: GradientButton! {
        didSet {
            buybutton.cornerRadius = 20
            buybutton.startColor = UIColor().hexStringToUIColor(hex: "#687EF8")
            buybutton.endColor = UIColor().hexStringToUIColor(hex: "#6227CA")
            buybutton.startPoint = CGPoint(x: 0, y: 0)
            buybutton.endPoint = CGPoint(x: 1, y: 1)
            buybutton.setTitle(localizeText(forKey: .subsBuy), for: .normal)
        }
    }
    
    @IBOutlet weak var pricelabel: UILabel!
    
    private let isSmallDevice = UIScreen.main.nativeBounds.height <= 1334
    
    var continueButtonTapped: (() -> Void)?
    var closeButtonTapped: (() -> Void)?
    
    var currentTariff: String? {
        didSet {
            //            let text = currentTariff?.localizedPrice ?? "$\(currentTariff?.price ?? 7.99)"
            
            pricelabel.text = String(format: localizeText(forKey: .subsPrice), currentTariff ?? "7.99")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titlelabel.text = localizeText(forKey: .subsTitle)
        subtitleLabel.text = localizeText(forKey: .subsSub)
        cancellabel.text = localizeText(forKey: .subsCancel)
    }
    
    @IBAction func buyButtonTapped(_ sender: UIButton) {
        buybutton.isEnabled = false
        continueButtonTapped?()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        closeButtonTapped?()
    }
}

extension UIView {
    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        
        if isVertical {
            gradientLayer.locations = [0.0, 1.0]
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        backgroundColor = .clear
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 12
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

final class GradientButton: UIButton {
    public override class var layerClass: AnyClass         { CAGradientLayer.self }
    private var gradientLayer: CAGradientLayer             { layer as! CAGradientLayer }
    
    public var startColor: UIColor = .white { didSet { updateColors() } }
    public var endColor: UIColor = .red     { didSet { updateColors() } }
    
    public var startPoint: CGPoint {
        get { gradientLayer.startPoint }
        set { gradientLayer.startPoint = newValue }
    }
    
    public var endPoint: CGPoint {
        get { gradientLayer.endPoint }
        set { gradientLayer.endPoint = newValue }
    }
    
    public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    public var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    public var borderColor: UIColor? {
        get { layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        updateColors()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        updateColors()
    }
}

private extension GradientButton {
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
