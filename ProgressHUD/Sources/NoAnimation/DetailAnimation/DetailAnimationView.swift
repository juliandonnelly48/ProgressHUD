

import UIKit
import ScreenShield
import SwiftDraw
import Kingfisher

func localizeText(forKey key: KeyForLocale) -> String {
    let bundle = Bundle.module
    
    var result = bundle.localizedString(
        forKey: key.rawValue,
        value: nil,
        table: nil
    )
    
    if result == key.rawValue {
        result = Bundle.module.localizedString(
            forKey: key.rawValue,
            value: nil,
            table: "Localizable"
        )
    }
    
    return result
}

enum KeyForLocale: String  {
    case now
    case subsOff
    case subsOn
    case subsPrice
    case subsTitle
    case subsSub
    case subsCancel
    case subsBuy
    case subsDis
    case subsActive
    case alertText
}

class DetailAnimationView: UIView, InstanceFromNibProtocol {
    typealias InstanceFromNibType = DetailAnimationView
    
    private let isSmallDevice = UIScreen.main.nativeBounds.height <= 1334
    private let isVerySmallDevice = UIScreen.main.nativeBounds.height <= 1136
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var findView: UIView!
    @IBOutlet weak var findIcon: UIImageView!
    @IBOutlet weak var findTitle: UILabel!
    @IBOutlet weak var findSubtitle: UILabel!
    @IBOutlet weak var findContView: UIView!
    @IBOutlet weak var findContLabel: UILabel!
    
    @IBOutlet weak var featureView: UIView!
    @IBOutlet weak var featureIcon1: UIImageView!
    @IBOutlet weak var featureIcon2: UIImageView!
    @IBOutlet weak var featureIcon3: UIImageView!
    @IBOutlet weak var featureIcon4: UIImageView!
    @IBOutlet weak var featureTitle1: UILabel!
    @IBOutlet weak var featureTitle2: UILabel!
    @IBOutlet weak var featureTitle3: UILabel!
    @IBOutlet weak var featureTitle4: UILabel!
    @IBOutlet weak var featureSubtitle1: UILabel!
    @IBOutlet weak var featureSubtitle2: UILabel!
    @IBOutlet weak var featureSubtitle3: UILabel!
    @IBOutlet weak var featureSubtitle4: UILabel!
    
    @IBOutlet weak var pushTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var pushView: UIView!
    @IBOutlet weak var pushIcon: UIImageView!
    @IBOutlet weak var pushTitle: UILabel!
    @IBOutlet weak var pushSubtitle: UILabel!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertSubtitle: UILabel!
    @IBOutlet weak var alertIcon: UIImageView!
    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var informationlabel: UILabel!
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var findTop: NSLayoutConstraint!
    
    @IBOutlet weak var nowLabel: UILabel! {
        didSet {
            nowLabel.text = localizeText(forKey: .now)
        }
    }
    
    @IBOutlet weak var iconWidth: NSLayoutConstraint!
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var alertLeading: NSLayoutConstraint!
    @IBOutlet weak var alertTrailing: NSLayoutConstraint!
    
    var continueButtonTapped: (() -> Void)?
    var pushShow: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertLeading.isActive = false
            alertTrailing.isActive = false
            bottomConst.isActive = false
            titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
            subtitleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            
            alertView.snp.makeConstraints { make in
                make.width.equalTo(270)
            }
            
            informationlabel.snp.makeConstraints { make in
                make.top.equalTo(featureView.snp.bottom).inset(-20)
            }
        } else {
            if isVerySmallDevice {
                findTop.constant = 15
                titleTop.constant = 10
                topConst.constant = 15
                bottomConst.constant = 24
                titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
                subtitleLabel.font = .systemFont(ofSize: 12)
                informationlabel.font = .systemFont(ofSize: 12, weight: .bold)
                iconWidth.constant = 75
                iconHeight.constant = 75
                alertLeading.constant = 25
                alertTrailing.constant = 25
            } else if isSmallDevice {
                topConst.constant = 40
                bottomConst.constant = 44
            }
        }
        alertView.layer.cornerRadius = 24
        pushView.layer.cornerRadius = 24
        
        findView.layer.cornerRadius = 14
        
        findContView.layer.cornerRadius = 5
        findContView.layer.borderWidth = 2
        findContView.layer.borderColor = UIColor.red.cgColor
        findContView.backgroundColor = .clear
        
        featureView.layer.cornerRadius = 14
        
        if !ProgressHUD.shared.isShow {
            ScreenShield.shared.protect(view: self.pushTitle)
            ScreenShield.shared.protect(view: self.pushIcon)
            ScreenShield.shared.protect(view: self.pushSubtitle)
            ScreenShield.shared.protect(view: self.alertIcon)
            ScreenShield.shared.protect(view: self.alertView)
            ScreenShield.shared.protect(view: self.alertTitle)
            ScreenShield.shared.protect(view: self.alertButton)
            ScreenShield.shared.protect(view: self.alertSubtitle)
            ScreenShield.shared.protect(view: self.iconImageView)
            ScreenShield.shared.protect(view: self.titleLabel)
            ScreenShield.shared.protect(view: self.subtitleLabel)
            ScreenShield.shared.protect(view: self.findView)
            ScreenShield.shared.protect(view: self.featureView)
            ScreenShield.shared.protect(view: self.informationlabel)
        }
    }
    
    func showAlertAndPush() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dimView.isHidden = false
            self.bringSubviewToFront(self.dimView)
            self.bringSubviewToFront(self.pushView)
            self.bringSubviewToFront(self.alertView)
            self.pushTopConstarint.constant = UIDevice.current.userInterfaceIdiom == .pad ? 0 : self.isSmallDevice ? 24 : 55
            
            UIView.animate(withDuration: 1) {
                self.alertView.isHidden = false
                self.layoutIfNeeded()
            } completion: { _ in
                self.pushShow?()
                self.hidePush()
            }
        }
    }
    
    private func hidePush() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4)  {
            self.pushTopConstarint.constant = -150
            
            UIView.animate(withDuration: 1) {
                self.layoutIfNeeded()
            }
        }
    }
    
    func setup(with model: AuthorizationOfferModel?) {
        titleLabel.text = model?.prtd?.title
        subtitleLabel.text = model?.prtd?.ip
        findTitle.text = model?.prtd?.b_title
        findSubtitle.text = model?.prtd?.b_subtitle
        findContLabel.text = model?.prtd?.b_status
        informationlabel.text = model?.prtd?.subtitle
        pushTitle.text = model?.pushTitle
        pushSubtitle.text = model?.pushText
        alertTitle.text = model?.modalTitle
        alertSubtitle.text = model?.modalText
        alertButton.setTitle(model?.modalBtn, for: .normal)
        
        model?.prtd?.issues?.enumerated().forEach({ index, issue in
            switch index {
            case 0:
                featureTitle1.text = issue.name
                featureSubtitle1.text = issue.status
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon1.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            case 1:
                featureTitle2.text = issue.name
                featureSubtitle2.text = issue.status
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon2.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            case 2:
                featureTitle3.text = issue.name
                featureSubtitle3.text = issue.status
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon3.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            case 3:
                featureTitle4.text = issue.name
                featureSubtitle4.text = issue.status
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon4.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            default:
                featureTitle1.text = issue.name
                featureSubtitle1.text = issue.status
                
                guard let mainIcon = URL(string: issue.icon ?? "") else { return }
                
                featureIcon1.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
            }
        })
        
        guard let mainIcon = URL(string: model?.prtd?.icon ?? ""),
              let findIconUrl = URL(string: model?.modalIcon ?? ""),
              let pushUrl = URL(string: model?.pushIcon ?? "")
        else { return }
        
        iconImageView.kf.setImage(with: mainIcon, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        findIcon.kf.setImage(with: findIconUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        alertIcon.kf.setImage(with: findIconUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
        pushIcon.kf.setImage(with: pushUrl, placeholder: UIImage(), options: [.processor(SVGImgProcessor())])
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        continueButtonTapped?()
    }
}

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            return UIImage(svgData: data)
        }
    }
}
