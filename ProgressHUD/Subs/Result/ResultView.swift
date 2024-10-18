

import UIKit
import Lottie
import AudioToolbox

class ResultView: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = ResultView
    
    private let isSmallDevice = UIScreen.main.nativeBounds.height <= 1334
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var animationTitle: UILabel!
    @IBOutlet weak var animationSubtitle: UILabel!
    @IBOutlet weak var bannerContainer: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var inactiveImageView: UIImageView!
    
    @IBOutlet weak var lhConst: NSLayoutConstraint!
    @IBOutlet weak var lwConst: NSLayoutConstraint!
    
    private let bannerView = BannerView.instanceFromNib()
    private var model: DataOfferObject?
    private var couter = 0
    private var progress: Float = 0
    @IBOutlet weak var circularProgress: CircularProgressView! {
        didSet {
            circularProgress.setProgressColor = UIColor().hexStringToUIColor(hex: "#65D65C")
            circularProgress.setTrackColor = UIColor(displayP3Red: 205.0/255.0, green: 247.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        }
    }
    private var timer: Timer?
    var timerBzz: Timer?
    
    var tariffButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isSmallDevice {
            topConst.constant = 20
            lhConst.constant = 250
            lwConst.constant = 250
            
            titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
        
        bannerContainer.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bannerView.tariffButtonTapped = { [weak self] in
            self?.tariffButtonTapped?()
        }
        
        bannerView.progressSwitchTapped = { [weak self] isOn in
            self?.setup(with: self?.model)
        }
    }
    
    func setup(with model: DataOfferObject?) {
        self.model = model
        bannerView.setup(with: model)
        backgroundColor = .white
        animationView.backgroundColor = .white
        
        if Storage.isTarifPaidAndActive {
            if Storage.isAllFeaturesEnabled, Storage.featuresStates.count == 6 {
                inactiveImageView.isHidden = true
                subtitleLabel.text = model?.scn?.subtitle_compl
                iconImageView.image = UIImage(resource: .vector)
                titleLabel.text = String(format: model?.scn?.title_compl ?? "", localizeText(forKey: .subsOn))
                animationSubtitle.text = String(format: model?.scn?.subtitle_anim_compl ?? "", localizeText(forKey: .subsOn))
                animationTitle.text = model?.scn?.title_anim_compl
                
                guard let url = URL(string: "https://checkerorganizerapp.com\(model?.scn?.anim_done ?? "")") else { return }
                
                animationView.isHidden = false
                LottieAnimation.loadedFrom(url: url, closure: { [weak self] animation in
                    self?.animationView.animation = animation
                    self?.animationView.play()
                }, animationCache: DefaultAnimationCache.sharedCache)
            } else {
                inactiveImageView.isHidden = false
                animationTitle.text = model?.scn?.title_anim_unp
                subtitleLabel.text = model?.scn?.subtitle_unp
                iconImageView.image = UIImage(resource: .inVector)
                titleLabel.text = String(format: model?.scn?.title_compl ?? "", localizeText(forKey: .subsOff))
                animationSubtitle.text = String(format: model?.scn?.subtitle_anim_compl ?? "", localizeText(forKey: .subsOff))
            }
            
            circularProgress.isHidden = false
            progress = 0
            
            Storage.featuresStates.forEach { state in
                if state.value {
                    progress += 1 / 6
                    
                    circularProgress.setProgressWithAnimation(duration: 1.0, value: progress)
                }
            }
        } else {
            circularProgress.isHidden = true
            titleLabel.text = String(format: model?.scn?.title_compl ?? "", localizeText(forKey: .subsOff))
            subtitleLabel.text = model?.scn?.subtitle_unp
            animationTitle.text = model?.scn?.title_anim_unp
            animationSubtitle.text = String(format: model?.scn?.subtitle_anim_compl ?? "", localizeText(forKey: .subsOff))
            animationView.isHidden = true
            inactiveImageView.isHidden = false
            iconImageView.image = UIImage(resource: .inVector)
        }
    }
    
    @objc func bzzz() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
